defmodule Bank.Accounts do
  import Ecto.Query, warn: false

  alias Bank.Repo
  alias Bank.Accounts.Account

  def get_account(id), do: Repo.get(Account, id)

  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
