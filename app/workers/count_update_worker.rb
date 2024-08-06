class CountUpdateWorker
    include Sidekiq::Worker

    def perform
        Application.joins(:chats).where('chats.created_at > ?', 10.minutes.ago).distinct.each do |application|
        application.update(chats_count: application.chats.count)
        end

        Chat.joins(:messages).where('messages.created_at > ?', 10.minutes.ago).distinct.each do |chat|
        chat.update(messages_count: chat.messages.count)
        end
    end
end