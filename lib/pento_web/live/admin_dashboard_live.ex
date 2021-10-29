defmodule PentoWeb.AdminDashboardLive do
  use PentoWeb, :live_view
  alias PentoWeb.Endpoint
  alias PentoWeb.{SurveyResultsLive, UserActivityLive, ProductSalesLive}

  @survey_results_topic "survey_results"
  @user_activity_topic "user_activity"

  @doc """
  Sets the inital state
  Once the socket connection has been initiated, subscribe to the survey results topic
  """
  def mount(_params, _session, socket) do

    if connected?(socket) do
      Endpoint.subscribe(@survey_results_topic)
      Endpoint.subscribe(@user_activity_topic)
    end

    {:ok,
    socket
    |> assign(:survey_results_component_id, "survey-results")
    |> assign(:user_activity_component_id, "user-activity")
    }

  end

  @doc """
  Handles the broadcast event from the client
  Once a rating has been created, it sends updates to the admin dashboard which recalculate the dashboard averages
  """
  def handle_info(%{event: "rating_created"}, socket) do
    send_update(
      SurveyResultsLive,
      id: socket.assigns.survey_results_component_id
    )
    {:noreply, socket}
  end


  
  def handle_info(%{event: "presence_diff"}, socket) do
    send_update(
      UserActivityLive,
      id: socket.assigns.user_activity_component_id)
    {:noreply, socket}
  end

end
