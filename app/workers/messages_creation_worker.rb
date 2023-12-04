class MessagesCreationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, number, params)
        @application = Application.where(token: token).first
        @chat = Chat.where(application_id: @application.id, number: number).first
        params = JSON.parse params
        params["chat_id"] = @chat.id
        @new_message = Message.new(params)
        @new_message.save
    end
end