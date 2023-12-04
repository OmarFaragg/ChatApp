class MessagesUpdateWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, chat_number, number, params)
        @application = Application.where(token: token).first
        @chat = Chat.where(application_id: @application.id, number: chat_number).first
        @message = Message.where(chat_id: @chat.id, number: number).first
        params = JSON.parse params
        @message.update(params)
    end
end