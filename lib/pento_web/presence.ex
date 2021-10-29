defmodule PentoWeb.Prescence do
  use Phoenix.Presence,
  otp_app: :pento,
  pubsub_server: Pento.PubSub

  alias Pento.Accounts
  alias PentoWeb.Prescence
  @user_activity_topic "user_activity"

  @moduledoc """
  Defines the presence model which is a data structure thattracks infromation about active user on the site
  """

  def track_user(pid, product, token) do
    user = Accounts.get_user_by_session_token(token)

    case Presence.get_by_key(@user_activity_topic, product.name) do
      [] ->
        Prescence.track(pid, @user_activity_topic, product.name, %{users: [%{email: user.email}]})
      %{users: active_users_for_product} ->
        Prescence.update(pid, @user_activity_topic, product.name, %{users: [active_users_for_product | %{email: user.email}]})
    end
  end
end
