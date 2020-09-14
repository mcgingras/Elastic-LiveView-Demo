defmodule Bank.Data.Items.Types.Account do
  @moduledoc false
  @attrs [
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

  @derive Jason.Encoder
  defstruct @attrs
end

defimpl Bank.Data.Items.Item, for: Bank.Data.Items.Types.Account do
  @moduledoc false

  def id(frob), do: frob.id
  def type(frob), do: frob.type
  def name(frob), do: frob.name
end

defimpl Bank.Data.Items.Prep, for: Bank.Accounts.Account do
  @moduledoc false

  alias Bank.Repo
  alias Bank.Accounts.Account
  alias Gf.Data.Slugs
  alias Gf.Data.Items.Shared
  alias Gf.Data.Items.Types.Product, as: ProductFrob
  alias Gf.Data.Items.Errors.MustBePersisted
  alias Gf.Data.Items.Errors.AssociationMissing
  alias Gf.Data.Items.Errors.AssociationNotLoaded
  alias Ecto.Association.NotLoaded

  def prep(%Account{id: nil}), do: raise(MustBePersisted)

  def prep(%Account{} = account) do
    account
    |> Map.merge(%{
      type: "account",
      sku: account.sku
    })
    |> Shared.cast(ProductFrob)
  end
end
