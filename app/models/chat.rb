class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages
  before_create :init

  def init
      self.messages_count = 0
  end
end
