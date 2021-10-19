
defmodule PentoWeb.ProductLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> allow_upload(:image,
        accept: ~w(.jpg .jpeg .png),
        max_entries: 1,
        auto_upload: true,
        progress: &handle_progress/3)
      }
  end

  @doc """
  Invoked on the allow_upload function on the socket
  Sends a progress event for each bit sent

  The first argument is the name of the upload field
  The second argument is the file being uploaded
  The third argument is the socket connection

  If the upload is done consume_uploaded_entry/3 is invoked
  consume_uploaded_entry takes the socket, the file being uploaded and a callback function
  """
  defp handle_progress(:image, entry, socket) do
    # :timer.sleep(1000)
    if entry.done? do
      path =
        consume_uploaded_entry(
          socket,
          entry,
          &upload_static_file(&1, socket)
        )
      {:noreply,
       socket
       |> put_flash(:info, "file #{entry.client_name} uploaded")
       |> update_changeset(:image_upload, path)}
    else
      {:noreply, socket}
    end
  end

  @doc """
  Extracts the changeset from the socket connection
  Add the image_upload attribute to the changeset
  """
  def update_changeset(%{assigns: %{changeset: changeset}} = socket, key, value) do
    socket
    |> assign(:changeset, Ecto.Changeset.put_change(changeset, key, value))
  end

  @doc """
  Interpolates the static directory with the filename
  Returns the route of the uploaded image
  """
  defp upload_static_file(%{path: path}, socket) do
    dest = Path.join("priv/static/images", Path.basename(path))
    File.cp!(path, dest)
    Routes.static_path(socket, "/images/#{Path.basename(dest)}")
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
