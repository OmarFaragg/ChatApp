class CountUpdateWorker                        
    include Sidekiq::Worker
                                          
    def perform()                     
        Application.all.each do |application|
            application.update(chats_count: application.chats.size)
            application.chats.all.each do |chat|
                chat.update(messages_count: chat.messages.size)
            end
        end        
    end                     
  end