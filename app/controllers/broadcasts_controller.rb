class BroadcastsController < ApplicationController
  before_action :set_broadcast, only: [:show, :destroy]
  before_action :set_current_page, except: [:index]
  rescue_from ActiveRecord::RecordNotFound, with: :squelch_record_not_found

  # This is an admin specific controller, so enforce access by admin only
  # This is a very simple form of authorisation
  before_action :admin_required
  
  # Require date package to get timestamp
  require 'date'

  # Default number of entries per page
  PER_PAGE = 12

  # GET /broadcasts
  def index
    @broadcasts = Broadcast.paginate(page: params[:page],
                                     per_page: PER_PAGE)
                           .order('created_at DESC')
  end

  # GET /broadcasts/1
  def show
    
  end

  # GET /broadcasts/new
  def new
    @broadcast = Broadcast.new
  end

  # POST /broadcasts
  def create
    @broadcast = Broadcast.new(broadcast_params)

    # Wire up broadcast with the current user (an administrator)
    # Will be an admin user (see before_action)
    # Note the current_user is a user_detail object so we need
    # to navigate to its user object
    @broadcast.user = current_user.user

    # Doing the next line forces a save automatically. I want to defer this
    # until the "if" statement
    #current_user.user.broadcasts << @broadcast

    no_errors = false
    respond_to do |format|
      if @broadcast.save
        # Only after saving do we try and do the real broadcast. Could have been
        # done using an observer, but I wanted this to be more explicit
        
        results = BroadcastService.broadcast(@broadcast, params[:feeds])
        if results.length > 0
          # Something went wrong when trying to broadcast to one or more of the
          # feeds.
          @broadcast.errors[:base] << ("#{I18n.t('broadcasts.unable-message')}: #{results.inspect}")
          flash[:error] = I18n.t('broadcasts.saved-but-message')
        else
          flash[:notice] = I18n.t('broadcasts.saved-message')
          no_errors = true
        end
        if no_errors
          format.html { redirect_to(broadcasts_url(page: @current_page)) }
          
          current_time = DateTime.now
          my_timestamp = current_time.strftime "%d/%m/%Y %H:%M"
          
          ActionCable.server.broadcast 'display_channel',
            message: '<p>Broadcast: ' + @broadcast.content.to_s + '<br/>',
            time_stamp: '@ ' + my_timestamp + '</p>'

        else
          format.html { render action: 'new' }
        end
      end
    end
  end

  # DELETE /broadcasts/1
  def destroy
    @broadcast.destroy
    respond_to do |format|
      format.html { redirect_to broadcasts_url }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_broadcast
    @broadcast = Broadcast.find(params[:id])
  end

  def set_current_page
    @current_page = params[:page] || 1
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def broadcast_params
    params.require(:broadcast).permit(:content)
  end

  def squelch_record_not_found(exception)
    respond_to do |format|
      format.html { redirect_to(broadcasts_url(page: current_page)) }
    end
  end
end
