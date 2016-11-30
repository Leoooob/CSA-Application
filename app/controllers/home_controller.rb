class HomeController < ApplicationController
  skip_before_action :login_required

  def index
    words = "kill me"
    
    ActionCable.server.broadcast 'display_channel',
        message: '<p>' + words.to_s + '</p>'
  end

end
