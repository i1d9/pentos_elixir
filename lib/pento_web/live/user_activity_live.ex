defmodule PentoWeb.UserActivityLive do
  use PentoWeb, :live_component
  alias PentoWeb.Prescence
  @user_activity_topic "user_activity"


  def update(_assigns, socket) do
    {:ok,
    socket
    |> assign_user_activity()
    }
  end

  def assign_user_activity(socket) do
    presence_map = Prescence.list(@user_activity_topic)

    user_activity =
      presence_map
      |> Enum.map(fn {product_name, _data} ->
        users =
          get_in(presence_map, [product_name, :metas]),
          |> List.first()
          |> get_in([:users])
        {product_name, users}
      end)

    assign(socket, :user_activity, user_activity)
  end
end
