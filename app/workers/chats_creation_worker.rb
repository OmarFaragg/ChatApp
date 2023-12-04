class ChatsCreationWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(token, params)
        @application = Application.where(token: token).first
        params = JSON.parse params
        params["application_id"] = @application.id
        @new_chat = Chat.new(params)
        @new_chat.save
    end
end