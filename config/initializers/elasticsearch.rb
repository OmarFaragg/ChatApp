require 'elasticsearch/rails'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'elasticsearch:9200',
  log: true,
)

Rails.application.config.after_initialize do
  require_dependency Rails.root.join('app/models/message').to_s

  Message.create_index_if_not_exists
end
