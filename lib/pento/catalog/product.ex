defmodule Pento.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float
    field :image_upload, :string

    timestamps()
  end

  @doc """
  Changeset casts unstructed user data into a known, structured form ensuring data safety
  Changesets capture differences between safe,consistent data and a proposed change, allowing efficiency
  Changesets validate data using known consistent rules, ensuring data consistency
  Changesets provide a contract for communicating error states and valid states ensuring a common interface for change
    
  The changeset/2 function captures differences between the structured item struct and the unstructructed attrs

  The cast/4 trims the changeset to the known attributes and converts them to the correct types ensuring safety
    
  The validate/2 and unique_constraint/2 functions validate the inbound data ensuring consistency
  """
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :unit_price, :sku, :image_upload])
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
    |> validate_number(:unit_price, greater_than: 0.0)
  end


  @doc """
  Chapter 3 challenge
  """
  def markdown_changeset(product, attrs, previous_unit_price) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_number(:unit_price, less_than: previous_unit_price)
  end

end
