RailsConfig.setup do |config|
  config.const_name = "Settings"
  config.use_env = true if ENV['HEROKU']
end
