defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  @doc """
  Establishes base query for returning all products
  """
  def base, do: Product


end
