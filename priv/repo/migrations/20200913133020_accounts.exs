defmodule Bank.Repo.Migrations.Accounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :account_number, :integer
      add :balance, :integer
      add :firstname, :string
      add :lastname, :string
      add :address, :string
      add :employer, :string
      add :email, :string
      add :city, :string
      add :state, :string

      # inserted_at and updated_at
      timestamps
    end
  end
end
