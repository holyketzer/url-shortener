require 'rack/attack'
require './config'

class Store
  def initialize
    @hash = Hash.new { |hash, key| hash[key] = 0 }
  end

  def increment(key, amount = 1, options = nil)
    @hash[key] += amount
  end

  def read(key, options = nil)
    @hash[key]
  end

  def write(key, value, options = nil)
    @hash[key] = value
  end
end


settings = Config.new.settings

if settings['rate_limit_enabled']
  Rack::Attack.cache.store = Store.new

  Rack::Attack.throttle('req/ip', limit: settings['requests_per_minute'], period: 60) do |req|
    if req.path == '/' && req.post?
      req.ip
    end
  end
end