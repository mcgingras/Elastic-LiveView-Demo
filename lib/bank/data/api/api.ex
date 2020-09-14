defmodule Bank.Data.API do
  alias Bank.Data.Queries

  @doc """
  Main function to request data from ES.

  params
  ------
  query_module: the query to run against elasticsearch.
  params: currently unclear what params you might pass.
  wrapper: the type spec, expected return type.
  options: unclear how this differs from params.
  """
  def search(query_module, params, wrapper, options \\ []) do
    Queries.run(query_module, params, wrapper, options)
  end
end
