# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

# remove when done with jsfiddle
# ActionCable.server.config.allowed_request_origins = ['http://fiddle.jshell.net']

run Rails.application
