require "yaml"

class Config
  def initialize(database_confing_path = "./config/database.yml")
    @database_settings = YAML.load(File.read(database_confing_path))
  end

  attr_reader :database_settings
end