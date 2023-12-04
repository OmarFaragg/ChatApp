class Application < ApplicationRecord
    has_many: chats
    before_create :init

    def init
        self.chats_count = 0
    end
end
