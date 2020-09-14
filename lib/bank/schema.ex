defmodule Bank.Schema do
  @moduledoc false
  defmacro __using__(_opts \\ []) do
    quote do
      use Ecto.Schema

      alias Bank.Repo
      alias __MODULE__
      alias Ecto.{Changeset, Schema}

      import Ecto.Changeset
      import Ecto.Query

      @timestamp_opts [type: :utc_datetime_usec]

      @type t :: %__MODULE__{}
    end
  end
end
