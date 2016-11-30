# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# allowed websocket request origins
ActionCable.server.config.allowed_request_origins = ['http://localhost:300', 'https://csa-application.herokuapp.com']

run Rails.application
