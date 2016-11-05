require "yaml"

class Config
  attr_reader :database_settings
  attr_reader :settings

  def initialize(database_confing_path = "./config/database.yml", settings_path = "./config/settings.yml")
    @database_settings = load_yaml(database_confing_path)
    @settings = load_yaml(settings_path)
  end

  def load_yaml(path)
    YAML.load(File.read(path))
  end
end