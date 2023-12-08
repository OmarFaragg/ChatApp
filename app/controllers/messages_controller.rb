class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show index ]

  # GET /applications/:application_token/chats/:chat_number/messages
  def index
    @messages = Message.select("number", "body").where(chat_id: @chat.id)

    render json: @messages, only: [:body, :number]
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:number
  def show
    @message = Message.select("number", "body").where(chat_id: @chat.id, number: params[:id]).first
    render json: @message, only: [:body, :number] 
  end

  # POST /applications/:application_token/chats/:chat_number/messages
  def create
    new_params = message_params
    redis_key = params[:application_id] + "." + params[:chat_id]
    if !REDIS.get(redis_key).present?
      @application = Application.where(token: params[:application_id]).first
      @chat = Chat.where(application_id: @application.id, number: params[:chat_id]).first
      REDIS.set(redis_key, @chat.messages.size)
    end
    REDIS.multi do
      REDIS.incr(redis_key)
    end
    new_params["number"] = REDIS.get(redis_key).to_i
    # REDIS.set(redis_key, new_params["number"])  
    MessagesCreationWorker.perform_async(params[:application_id], params[:chat_id], new_params.to_json)
    render json: {"number": new_params["number"]}
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:number
  def update
    new_params = message_params
    MessagesUpdateWorker.perform_async(params[:application_id], params[:chat_id], params[:id], new_params.to_json)
    render json: {"status": "Update in Progress."}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @application = Application.where(token: params[:application_id]).first
      @chat = Chat.where(application_id: @application.id, number: params[:chat_id]).first
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body)
    end
end
