class ChatsUpdateWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, number, params)
        @application = Application.where(token: token).first
        @chat = Chat.where(number: number, application_id: @application.id).first
        params = JSON.parse params
        @chat.update(params)
    end
end