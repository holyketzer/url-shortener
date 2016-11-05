require "mysql2"
require "./config"

settings = Config.new.database_settings

client = Mysql2::Client.new(host: settings["host"], username: settings["username"])

client.query("CREATE DATABASE IF NOT EXISTS #{settings["database"]};")
puts "DB created"

# A-z and a-z and 0-9 = 62 chars, 8 positions = 218_340_105_584_896 combinations, should be enough

client.select_db(settings["database"])
client.query(<<-SQL
  CREATE TABLE IF NOT EXISTS urls (
    id CHAR(8) NOT NULL,
    url VARCHAR(2048) NOT NULL,
    PRIMARY KEY (id)
  )
  SQL
)
puts "Table created"
