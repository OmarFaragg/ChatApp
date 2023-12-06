require 'elasticsearch/rails'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'localhost:9200',
  log: true,
)