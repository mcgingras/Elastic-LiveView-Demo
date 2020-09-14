defmodule Bank.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :bank
end
