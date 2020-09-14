defmodule Bank.Data.Queries do
  @callback search(map()) :: map()
  @callback index() :: String.t()
  @callback repo(map()) :: Ecto.Queryable.t()

  alias Bank.Data.Actions

  def run!(query_module, params, wrapper, options \\ []) do
    case run(query_module, params, wrapper, options) do
      {:ok, response} -> response
      {:error, error} -> raise error
    end
  end

  def run(query_module, params, wrapper, options \\ []) do
    search(query_module, params, wrapper, options)
  end

  @doc """
  Search ES with the given query, returning {results, meta}
  if the query ran, or nil if no such query exists.
  """
  def search(query_module, params, wrapper, options) do
    case query_module.search(params) do
      nil ->
        nil

      query ->
        index = query_module.index
        Actions.search(query, index, wrapper)
    end
  end
end
