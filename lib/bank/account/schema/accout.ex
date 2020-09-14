defmodule Bank.Accounts.Account do
  @moduledoc false

  use Bank.Schema

  schema "accounts" do
    field(:account_number, :integer)
    field(:balance, :integer)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:address, :string)
    field(:employer, :string)
    field(:email, :string)
    field(:city, :string)
    field(:state, :string)
    timestamps()
  end

  @fields [
    :account_number,
    :balance,
    :firstname,
    :lastname,
    :address,
    :employer,
    :email,
    :city,
    :state
  ]

  @spec changeset(
          {map, map} | %{:__struct__ => atom | %{__changeset__: map}, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  def changeset(address, params \\ %{}) do
    address
    |> cast(params, @fields)
  end
end

defimpl Elasticsearch.Document, for: Bank.Accounts.Account do
  def id(account), do: account.id
  def routing(_), do: false

  def encode(account) do
    %{
      account_number: account.account_number,
      balance: account.balance,
      firstname: account.firstname,
      lastname: account.lastname,
      address: account.address,
      employer: account.employer,
      email: account.email,
      city: account.city,
      state: account.state
    }
  end
end
