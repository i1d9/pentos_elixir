defmodule PentoWeb.RatingLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_rating()
      |> assign_changeset()
    }
  end

  @doc """
  Builds a new rating for a specific user and product
  """
  def assign_rating(%{assigns: %{user: user, product: product}} = socket) do
    assign(socket, :rating, %Rating{user_id: user.id, product_id: product.id})
  end

  @doc """
  Builds a changeset for that function
  """
  def assign_changeset(%{assigns: %{rating: rating}} = socket) do
    assign(socket, :changeset, Survey.change_rating(rating))
  end

  def handle_event("validate", %{"rating" => rating_params}, socket) do
    {:noreply, validate_rating(socket, rating_params)}
  end

  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, save_rating(socket, rating_params)}
  end

  @doc """
  Validates the changeset and returns a socket with the validated changeset
  """
  def validate_rating(socket, rating_params) do
    changeset =
      socket.assigns.rating
      |> Survey.change_rating(rating_params)
      |> Map.put(:action, :validate)

    assign(socket, :changeset, changeset)
  end

  @doc """
  When the creation of a rating is successful, we send a message to the parent process
  On failure the changeset is returned
  """
  def save_rating(%{assigns: %{product_index: product_index, product: product}} = socket, rating_params) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:create_rating, product, product_index})
      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  




end
