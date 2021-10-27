defmodule PentoWeb.SurveyResultsLive do
  use PentoWeb, :live_component

  alias Pento.Catalog
  alias Contex


  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign_age_group_filter()
      |> assign_products_with_average_ratings()
      |> assign_dataset()
      |> assign_chart()
      |> assign_chart_svg()
    }
  end

  def assign_age_group_filter(socket) do
    socket
    |> assign(:age_group_filter, "all")
  end

  @doc """
  Add the query result of the averaged products to the state
  """
  def assign_products_with_average_ratings(%{assigns: %{age_group_filter: age_group_filter}}=socket) do
    socket
    |> assign(:products_with_average_ratings, Catalog.products_with_average_ratings(%{age_group_filter: age_group_filter}))
  end


  @doc """
  Pattern match to extract product_average ratings from the socket
  """
  def assign_dataset(%{
    assigns: %{products_with_average_ratings: products_with_average_ratings}
    } = socket) do
    socket
    |> assign(
      :dataset,
      make_bar_chart(products_with_average_ratings)
    )
  end

  @doc """
  Pattern match to extract the dataset from the socket
  """
  defp assign_chart(%{assigns: %{dataset: dataset}} = socket) do
    socket
    |> assign(:chart, make_bar_chart(dataset))
  end

  defp make_bar_chart_dataset(data) do
    Contex.Dataset.new(data)
  end

  @doc """
  Create a bar chart from the queried data
  """
  defp make_bar_chart(data) do
    Contex.BarChart.new(data)
  end

  def assign_chart_svg(%{assigns: %{chart: chart}} = socket) do
    socket
    |> assign(:chart_svg, render_bar_chart(chart))
  end

  defp render_bar_chart(chart) do
    Plot.new(500, 400, chart)
    |> Plot.titles(title(), subtitle())
    |> Plot.axis_labels(x_axis(), y_axis())
    |> Plot.to_svg()
  end

  defp title do
    "Product Ratings"
  end

  defp subtitle do
    "average star ratings per product"
  end

  defp x_axis do
    "products"
  end

  defp y_axis do
    "stars"
  end

end
