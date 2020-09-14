defmodule Bank.ElasticsearchStore do
  @moduledoc false
  @behaviour Elasticsearch.Store

  alias Bank.Repo

  def stream(Bank.Accounts.Account) do
    Bank.Accounts.Account
    |> Repo.stream()
  end

  @impl true
  def stream(schema) do
    Repo.stream(schema)
  end

  @impl true
  def transaction(fun) do
    {:ok, result} = Repo.transaction(fun, timeout: :infinity)
    result
  end
end
