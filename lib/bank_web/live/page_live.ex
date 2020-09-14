defmodule BankWeb.PageLive do
  use BankWeb, :live_view

  alias Bank.Data.API
  alias Bank.Data.Items.Types.Account, as: AccountFrob
  alias Bank.Data.Queries.MainSearchQuery, as: MSQ

  @impl true
  def mount(_params, _session, socket) do
    case API.search(MSQ, %{text: ""}, AccountFrob) do
      {:ok, response} ->
        {:ok,
         assign(socket, %{
           results: response.results
         })}

      {:error, error} ->
        IO.inspect(error)
        {:ok, socket}
    end
  end

  @impl true
  def handle_event("search", params, socket) do
    text = params["search"]

    case API.search(MSQ, %{text: text}, AccountFrob) do
      {:ok, response} ->
        {:noreply,
         assign(socket, %{
           results: response.results
         })}

      {:error, error} ->
        IO.inspect(error)
        {:noreply, socket}
    end
  end
end
