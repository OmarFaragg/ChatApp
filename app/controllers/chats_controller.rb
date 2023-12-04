class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show index update ]

  # GET applications/:application_token/chats
  def index
    @chats = Chat.select("title", "messages_count", "number").where(application_id: @application.id)

    render json: @chats, only: [:title, :number, :messages_count]
  end

  # GET applications/:application_token/chats/:number
  def show
    @chat = Chat.select("title", "messages_count", "number").where(application_id: @application.id, number: params[:id]).first
    render json: @chat, only: [:title, :number, :messages_count]
  end

  # POST applications/:application_token/chats/
  def create
    new_params = chat_params
    if !REDIS.get(params[:application_id]).present?
      REDIS.set(params[:application_id], Application.where(token: params[:application_id]).fisrt.chats.size)
    end
    new_params["number"] = REDIS.get(params[:application_id]).to_i + 1
    REDIS.set(params[:application_id], new_params["number"])  
    ChatsCreationWorker.perform_async(params[:application_id], new_params.to_json)
    render json: {"number": new_params["number"]}
  end

  # PATCH/PUT applications/:application_token/chats/:number
  def update
    new_params = chat_params
    ChatsUpdateWorker.perform_async(params[:application_id], params[:id], new_params.to_json)
    render json: {"status": "Update in Progress."}
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @application = Application.where(token: params[:application_id]).first
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:title)
    end
end
