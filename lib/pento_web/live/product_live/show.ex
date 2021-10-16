defmodule PentoWeb.ProductLive.Show do
  use PentoWeb, :live_view

  alias Pento.Catalog

  @impl true
  @doc """
  Sets the initalial state
  """
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @doc """
  Patterns match the params and extracts the id from the URL 
  Takes the same params as the mount function and a trigger
  """
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, Catalog.get_product!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
