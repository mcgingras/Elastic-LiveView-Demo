defmodule Bank.Data.Search.DSL.Boolean do
  @moduledoc """
  DSL nodes for boolean queries/filters.
  """

  import Bank.Data.Search.DSL.Query

  def boolean(queries, opts \\ []), do: add(:bool, queries, opts)
  def intersection(queries, _opts \\ []), do: add(:must, queries)
  def union(queries, _opts \\ []) when is_list(queries), do: add(:should, queries)
end
