defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Demographic

  def update(assigns, socket) do
    {:ok,
    socket
    |> assign(assigns)
    |> assign_demographic()
    |> assign_changeset()
    }
  end

  @doc """
  Pattern matches to extract user in the assign map in the socket struct
  """
  def assign_demographic(%{assigns: %{user: user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end


  def handle_event("save", %{"demographic" => demographic_params}, socket) do
    IO.puts "Handling 'save' event and saving demographic record..."
    IO.inspect(demographic_params)
    {:noreply, save_demographic(socket, demographic_params)}
  end

  @doc """
  The form component is running in the parent's process and therefore share the same pid.
  Sends a message to the parent
  """
  def save_demographic(socket, demographic_params) do
    case Survey.create_demographic(demographic_params) do
      {:ok, demographic} ->
        # Coming soon!
        send(self(), {:created_demographic, demographic})
        socket
      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

end
