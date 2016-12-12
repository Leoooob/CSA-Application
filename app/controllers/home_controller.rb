class HomeController < ApplicationController
  skip_before_action :login_required

  def index
    @broadcasts = Broadcast.order('created_at DESC')
  end

end
