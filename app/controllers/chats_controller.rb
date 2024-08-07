class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show index update search ]

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
    application_id = params[:application_id]
  
    unless REDIS.exists(application_id)
      application = Application.find_by(token: application_id)
      REDIS.set(application_id, application.chats.size)
    end

    new_params["number"] = REDIS.incr(application_id)

    ChatsCreationWorker.perform_async(application_id, new_params.to_json)
    render json: {"number": new_params["number"]}
  end

  # PATCH/PUT applications/:application_token/chats/:number
  def update
    new_params = chat_params
    ChatsUpdateWorker.perform_async(params[:application_id], params[:id], new_params.to_json)
    render json: {"status": "Update in Progress."}
  end

  # POST applications/:application_token/chats/:number/search/:query
  def search
    @chat = Chat.select("id", "number").where(application_id: @application.id, number: params[:id]).first
  
    response = Message.search({
      query: {
        bool: {
          must: [
            {
              match: {
                body: params[:query]
              }
            }
          ],
          filter: [
            {
              term: {
                chat_id: @chat.id
              }
            }
          ]
        }
      }
    })

    res = []
    response.records.as_json.each do |rec|
      res.append(rec.except("id", "chat_id", "created_at", "updated_at"))
    end
    render json: res
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
