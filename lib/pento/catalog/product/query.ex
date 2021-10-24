defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating
  alias Pento.Repo

  @doc """
  Establishes base query for returning all products
  """
  def base, do: Product

  @doc """
  Explicitly load relationships using preload
  """
  def with_user_ratings(query \\ base(), user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)

  end

end
