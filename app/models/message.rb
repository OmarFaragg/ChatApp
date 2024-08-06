class Message < ApplicationRecord
  belongs_to :chat
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { 
    number_of_shards: 1, 
    analysis: {
      filter: {
        edge_ngram_filter: {
          type: "edge_ngram",
          min_gram: 2,
          max_gram: 3
        }
      },
      analyzer: {
        edge_ngram_analyzer: {
          type: "custom",
          tokenizer: "standard",
          filter: ["lowercase", "edge_ngram_filter"]
        }
      }
    }
  } do
    mappings dynamic: 'false' do
      indexes :chat_id, type: :integer
      indexes :number, type: :integer
      indexes :body, type: :text, analyzer: "edge_ngram_analyzer"
    end
  end

  after_commit on: [:create, :update] do
    __elasticsearch__.index_document
  end

  after_commit on: [:destroy] do
    __elasticsearch__.delete_document
  end

  def self.create_index_if_not_exists
    unless self.__elasticsearch__.index_exists?
      self.__elasticsearch__.create_index!
    end
  end
end
