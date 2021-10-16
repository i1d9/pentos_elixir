defmodule Pento.Promo do
    alias Pento.Promo.Recipient

    def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
        Recipient.changeset(recipient, attrs)
    end

    def send_promo(recipient, attrs) do
        # Send email to promo recipient
    end
end