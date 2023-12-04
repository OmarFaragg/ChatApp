class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show update ]

  # GET /applications
  def index
    @applications = Application.select("token", "name", "chats_count")

    render json: @applications, only: [:name, :token, :chats_count]
  end

  # GET /applications/token
  def show
    render json: @application, only: [:name, :chats_count]
  end

  # POST /applications
  def create
    token = SecureRandom.uuid
    # new_params = JSON::parse(application_params.to_json)
    new_params = application_params
    new_params['token'] = token
    new_params['previous_request_timestamp'] = DateTime.now
    ApplicationsCreationWorker.perform_async(new_params.to_json)
    render json: {"token": token}
    
  end

  # PATCH/PUT /applications/token
  def update
    new_params = application_params
    ApplicationsUpdateWorker.perform_async(params[:id], new_params.to_json)
    render :json => {"status" => "Update in progress."}
  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.where(token: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
