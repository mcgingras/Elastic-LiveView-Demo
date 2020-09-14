defmodule Bank.Data.Search.DSL.FullText do
  @moduledoc """
  DSL nodes for full text searches. Can search on one
  or more fields. Any sort of atom query is a noop, but
  particularly nil.
  """

  def text_contains(query: query, fields: _) when is_atom(query) or query == "", do: nil

  def text_contains(query: query, fields: field) when is_binary(query) and is_atom(field) do
    %{
      match: %{
        field => %{
          query: query
        }
      }
    }
  end

  def text_contains(query: query, fields: fields) when is_binary(query) and is_list(fields) do
    %{
      multi_match: %{
        query: query,
        fields: fields |> Enum.map(&Atom.to_string/1)
      }
    }
  end
end
