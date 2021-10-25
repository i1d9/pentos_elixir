defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Catalog, Accounts, Survey}

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
    }
  end

  @doc """
  The assign_new/3 function is used to access the assigns from the Plug.Conn when the live view first mounts
  When the live view first mounts in the disconnected state, the Plug.Conn assigns is available inside the live view's socket under socket.private.assign_new.
  This allows the connection assigns to be shared for the initial HTTP request. The Plug.Conn assigns is not available in the connected state.
  """
  defp assign_user(socket, token) do
    IO.puts "Assign User with socket.private:"
    IO.inspect socket.private
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

end
