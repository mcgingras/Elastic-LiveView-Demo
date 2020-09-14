defmodule Mix.Tasks.Dump do
  use Mix.Task

  alias Bank.Accounts
  alias Bank.Accounts.Account

  @impl true
  @spec run(any) :: any
  def run([csv_path]) do
    Mix.Task.run("app.start", [])

    # Silence SQL logging during import
    Logger.configure(level: :warn)

    IO.puts("dumping accounts from path to postgres...")
    dump_accounts(csv_path)
  end

  def dump_accounts(path) do
    File.stream!(path)
    |> Stream.with_index()
    |> Stream.map(fn {line, index} ->
      case rem(index, 2) do
        0 -> nil
        1 -> to_store(line)
      end
    end)
    |> Stream.run()
  end

  defp to_store(line) do
    line = Poison.decode!(line)
    Accounts.create_account(line)
  end

  def run(_) do
    Mix.shell().error("Usage: mix dump path/to/accounts.json")
  end
end
