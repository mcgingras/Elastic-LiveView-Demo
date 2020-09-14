defmodule Bank.Data.Queries.MainSearchQuery do
  @moduledoc """
  The main query to fetch results.
  """
  @standard_text_fields [
    :firstname,
    :lastname,
    :employer,
    :address,
    :state,
    :city
  ]

  import Bank.Data.Search.DSL.{
    Query,
    FullText,
    Boolean
  }

  def index, do: "accounts-1599967176519232"

  @doc """
  Returns a map representing an ES query.
  """
  def search(%{text: text}) do
    text_query = text_contains(query: text, fields: @standard_text_fields)

    as_query(fn _ ->
      add(:bool, intersection([text_query]))
    end)
  end
end
