class Api < Rails::Application
  config.external_apis = config_for(:apis)
end
