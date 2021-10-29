defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias PentoWeb.Prescence
  alias Pento.Accounts

  @impl true
  @doc """
  Sets the initial state
  """
  def mount(_params, %{"user_token" => token}, socket) do
    {:ok, assign(socket, :user_token, token)}
  end

  @impl true
  @doc """
  Patterns match the params and extracts the id from the URL
  Takes the same params as the mount function and a trigger
  """
  def handle_params(%{"id" => id}, _, socket) do
    product = Catalog.get_product!(id)
    maybe_track_user(product, socket)
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)}
  end

  def maybe_track_user(product, %{assigns: %{live_action: :show, user_token: user_token}}) do
    if connected?(socket) do
      Presence.track_user(self(), product, socket.assigns.user_token)
    end
  end

  def maybe_track_user(product, socket), do: nil


  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
