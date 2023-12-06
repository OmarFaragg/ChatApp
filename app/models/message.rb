class Message < ApplicationRecord
  belongs_to :chat
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :chat_id, type: :integer
      indexes :number, type: :integer
      indexes :body, type: :text
    end
  end

  after_commit on: [:create, :update] do
    __elasticsearch__.index_document 
  end
end
