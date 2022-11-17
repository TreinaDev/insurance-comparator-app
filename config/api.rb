require_relative "application"
class Api < Rails::Application
  config.external_apis = config_for(:apis)
  # Rails.application.config_for(:apis).symbolize_keys
end
