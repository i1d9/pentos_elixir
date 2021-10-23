defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "demographics" do
    field :gender, :string
    field :year_of_birth, :integer
    belongs_to :user, Pento.Accounts.User

    timestamps()
  end

  @doc """
  Ensures that the fields need by the relationship are are available
  """
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, [:gender, :year_of_birth, :user_id])
    |> validate_required([:gender, :year_of_birth, :user_id])
    |> validate_inclusion(:gender, ["male", "female", "other", "prefer not to say"])
    |> validate_inclusion(:year_of_birth, 1990..Date.utc_today.year)
    |> unique_constraint(:user_id)
  end
end
