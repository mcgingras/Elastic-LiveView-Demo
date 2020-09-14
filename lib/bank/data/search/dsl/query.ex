defmodule Bank.Data.Search.DSL.Query do
  @moduledoc """
  Generic search query business.
  """
  @cluster Gf.Data.Search.Cluster

  alias Gf.Data.Search.Errors.NullQuery
  @match_all %{query: %{match_all: %{}}}

  @doc """
  Given a function that returns a DSL node, turn that node into a query object.
  """
  def as_query(query, opts \\ []), do: add(:query, query, opts)

  @doc """
  Given a function that returns a DSL node, turn that node into a filter object.
  """
  def as_filter(query, opts \\ []), do: add(:filter, query, opts)

  @doc """
  Noop on symbol query (think nil, but also true); otherwise make a new map
  keyed by field.
  """
  def add(field, query, opts \\ [])
  def add(_, query, _) when is_atom(query), do: nil
  def add(field, query, opts) when is_atom(field), do: %{field => ask_for(query, opts)}

  @doc """
  Filters nil queries from lists, runs functions, leaves maps untouched. Atoms
  (think nil) are noops.
  """
  def ask_for(query, opts \\ [])
  def ask_for(query, _opts) when is_map(query), do: query
  def ask_for(func, opts) when is_function(func), do: apply(func, [opts])

  def ask_for(queries, opts) when is_list(queries) do
    queries |> Enum.filter(&(!!&1)) |> Enum.map(fn q -> ask_for(q, opts) end)
  end

  def ask_for(query, _opts) when is_atom(query), do: nil

  @doc """
  Add a from parameter for pagination.
  """
  def with_from(query, ""), do: query
  def with_from(query, from) when is_nil(from), do: query
  def with_from(query, from) when is_binary(from), do: with_from(query, String.to_integer(from))
  def with_from(query, from) when is_integer(from), do: Map.merge(query, %{from: from})

  def with_size(query, ""), do: query
  def with_size(query, size) when is_nil(size), do: query
  def with_size(query, size) when is_binary(size), do: with_size(query, String.to_integer(size))
  def with_size(query, size) when is_integer(size), do: Map.merge(query, %{size: size})
end
