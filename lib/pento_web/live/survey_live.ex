defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  alias Pento.{Catalog, Accounts, Survey}

  @survey_results_topic "survey_results"

  @impl true
  @doc """
  The mount/3 function is called twice for every live view.
    1. The initial page load
    2. When establishing the live socket connection
  Pattern match and grab the user_token from the session argument
  The session is made available in any live view as the second argument to the mount/3 function
  """
  def mount(_params, %{"user_token" => token} = _session, socket) do
    {:ok,
    socket
    |> assign_user(token)
    |> assign_demographic()
    |> assign_products()
    }
  end

  @doc """
  The assign_new/3 function is used to access the assigns from the Plug.Conn when the live view first mounts
  When the live view first mounts in the disconnected state, the Plug.Conn assigns is available inside the live view's socket under socket.private.assign_new.
  This allows the connection assigns to be shared for the initial HTTP request. The Plug.Conn assigns is not available in the connected state.
  """
  def assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)
  end

  def assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :demographic, Survey.get_demographic_by_user(current_user))
  end


  def assign_products(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :products, list_products(current_user))
  end

  defp list_products(user) do
    Catalog.list_products_with_user_ratings(user)
  end

  @impl true
  @doc """
  Recieves a message from the form_component and matches the tuple sent by it
  """
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, handle_demographic_created(socket, demographic)}
  end

  @impl true
  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, handle_rating_created(socket, updated_product, product_index)}
  end

  def handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  @doc """
  Adds the flash message and updates the product list with its rating.
  Broadcasts an event to the admin
  """
  def handle_rating_created(%{assigns: %{products: products}} = socket, updated_product, product_index) do
    Endpoint.broadcast!(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(:products, List.replace_at(products, product_index, updated_product))
  end
end
