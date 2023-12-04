class Chat < ApplicationRecord
  belongs_to :application
  before_create :init

  def init
      self.messages_count = 0
  end
end
