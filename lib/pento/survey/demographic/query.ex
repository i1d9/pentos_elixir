defmodule Pento.Survey.Demographic.Query do
  import Ecto.Query
  alias Pento.Repo
  alias Pento.Survey.Demographic

  @doc """
  Base Query
  """
  def base, do: Demographic

  @doc """
  Filter query by user,
  Pattern matches without bounding the variable
  """
  def for_user(query \\ base(), user) do
    query
    |> where([d], d.user_id == ^user.id)
  end

  @doc """
  This reducer takes a type applies some functions then returns the manipulated type
  """
  def get_demographic_by_user(user) do
    user
    |> Demographic.Query.for_user()
    |> Repo.one()
  end

end
