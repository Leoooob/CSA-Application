class Api::BroadcastsController < Api::ApplicationController
  before_action :set_broadcast, only: [:show, :destroy]
  before_action :set_current_page, except: [:index]
  rescue_from ActiveRecord::RecordNotFound, with: :squelch_record_not_found

  # This is an admin specific controller, so enforce access by admin only
  # This is a very simple form of authorisation
  before_action :admin_required
  
  # Require date package to get timestamp
  require 'date'

  # Default number of entries per page
  PER_PAGE = 20

  # GET /broadcasts.json
  def index
    @broadcasts = Broadcast.paginate(page: params[:page],
                                     per_page: params[:per_page])
                           .order('created_at DESC')
  end

  # GET /broadcasts/1.json
  def show
    
  end

  # POST /broadcasts.json
  def create
    @broadcast = Broadcast.new(broadcast_params)
    @broadcast.user = current_user.user

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
          format.json { render json: @broadcast, status: :created, location: @broadcast }
          
          current_time = DateTime.now
          my_timestamp = current_time.strftime "%d/%m/%Y %H:%M"
          
          ActionCable.server.broadcast 'display_channel',
            message: '<p><strong>Broadcast</strong>: ' + @broadcast.content.to_s + '<br/>',
            time_stamp: '@ ' + my_timestamp + '</p>'
        else
          format.json {
            # Either say it partly worked but send back the errors or else send
            # back complete failure indicator (couldn't even save)
            if results
              render json: @broadcast.errors, status: :created, location: @broadcast
            else
              render json: @broadcast.errors, status: :unprocessable_entity
            end
          }
        end
      end
    end
  end

  # DELETE /broadcasts/1.json
  def destroy
    @broadcast.destroy
    respond_to do |format|
      format.json { head :no_content }
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
      format.json { head :no_content }
    end
  end
end
