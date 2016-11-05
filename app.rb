require "em-synchrony"
require "em-synchrony/mysql2"
require "json"
require "sinatra/base"
require "sinatra/synchrony"

require "./config"
require './uid_generator'

class App < Sinatra::Base
  register Sinatra::Synchrony

  MYSQL_DUP_ENTRY_ERROR = 1062

  settings = Config.new.database_settings
  uid_generator = UidGenerator.new

  get '/:uid' do |uid|
    client = Mysql2::EM::Client.new(settings)
    res = client.query("SELECT url from urls where id = '#{uid}'")

    if res.count > 0
      redirect res.first['url'], 301
    else
      status 404
      body 'not found'
    end
  end

  post '/' do
    body = JSON.parse(request.body.read)
    longUrl = body["longUrl"]
    if longUrl && longUrl.size > 0
      client = Mysql2::EM::Client.new(settings)

      begin
        uid = uid_generator.generate
        res = client.query("INSERT INTO urls (id, url) values ('#{uid}', '#{longUrl}')")

        content_type :json
        body({ url: "#{request.base_url}/#{uid}" }.to_json)
      rescue Mysql2::Error => e
        if e.error_number == MYSQL_DUP_ENTRY_ERROR
          retry
        else
          raise
        end
      end
    else
      status 400
      body 'longUrl parameter required'
    end
  end
end