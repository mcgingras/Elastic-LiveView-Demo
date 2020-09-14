defmodule Bank.Data.Actions do
  alias Bank.Data.Search.Response
  @cluster Bank.ElasticsearchCluster

  @doc """
  The actual call to elasticsearch that fetches the results.

  params
  ------
  query: the query to run against elasticsearch.
  index: the index to search into.
  """
  def search(query, index, wrapper) do
    path = "/#{index}/_search"

    case Elasticsearch.post(@cluster, path, query) do
      {:ok, raw} -> {:ok, Response.parse!(raw, wrapper)}
      {:error, error} -> IO.inspect(error)
    end
  end
end
