defmodule PentoWeb.PromoLive do
    use PentoWeb, :live_view
    alias Pento.Promo
    alias Pento.Promo.Recipient

    def mount(_params, _session, socket) do
        {:ok, 
            socket
            |> assign_recipient()
            |> assign_changeset()}
    end

    @doc """
    Save the Recipient struct in the socket connection state
    """
    def assign_recipient(socket) do
        socket
        |> assign(:recipient, %Recipient{})
    end

    @doc """
    Save the changeset to the socket connection state
    """
    def assign_changeset(%{assigns: %{recipient: recipient}} = socket) do
        socket
        |> assign(:changeset, Promo.change_recipient(recipient))
    end

    @doc """
    Handles the onchange event on the form
    Pattern matches to extract the recipient struct from the socket
    Extracts the send params from the form and bounds them to recipient_params
    The change_recipient function compares the Recipient struct to the inbound data from the form

    The form errors are displayed when the changeset's action is :validate
    """
    def handle_event("validate", %{"recipient" => recipient_params},
    %{assigns: %{recipient: recipient}} = socket
    ) do
        changeset = 
            recipient
            |> Promo.change_recipient(recipient_params)
            |> Map.put(:action, :validate)
        {:noreply,
        socket
        |> assign(:changeset, changeset)
        }
        
    end

    def handle_event("save", %{"recipient" => recipient_params}, socket) do
        :timer.sleep 1000
    end

end