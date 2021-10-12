defmodule PentoWeb.ProductLive.Index do
  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Product


  @moduledoc """
  A liveview is initailly a normal GET request then a websocket connection is instanciated.
  Once the socket has been instaniated the handle_params/3 is called to process any paramters 
  that may have been passed on the URL.
  The handle_params method can be discarded if no paramter processing is required
  The next function to be executed is the mount/3 which is used to initalize the state using the assigns/3 function
  The states can be accessed in the templates and are used to trigger re-rendering of specific parts of the template
  The next function to be executed is the render function if it is not defined the live view module will look for a
  template with the same name as the callling liveview module which follows phoenix naming convenction 
  """

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
    socket
    |> assign(:greeting, "Welcome to Pento!")
    |> assign(:products, list_products())
    }
    
  end

  @impl true
  @doc """
  Called after the initial get method
  """
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Catalog.list_products()
  end
end
