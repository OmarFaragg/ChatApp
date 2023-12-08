require 'elasticsearch/rails'

Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: ENV['ELASTICSEARCH_URL'] || 'elasticsearch:9200',
  log: true,
)
