defmodule Pento.Promo.Recipient do
    defstruct [:first_name, :email]
    @types %{first_name: :string, email: :string} 

    alias Pento.Promo.Recipient
    import Ecto.Changeset


    @doc """
    1. Compares the Recipient struct with the inbound data attrs
    2. Checks whether the unstructed data has a key of firstname and email defined with values
    3. Checks the format of the unstructed data field email against a regex
    """
    def changeset(%Recipient{} = user, attrs) do
        {user, @types}
        |> cast(attrs, Map.keys(@types))
        |> validate_required([:first_name, :email])
        |> validate_format(:email, ~r/@/)
    end
end