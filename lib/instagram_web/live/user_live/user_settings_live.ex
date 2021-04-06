defmodule InstagramWeb.UserSettingsLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias Instagram.Uploaders.Avatar

  @extension_whitelist ~w(.jpg .jpeg .png)


  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    changeset = User.update_changeset(socket.assigns.current_user, %{})

    {:ok,
      socket
      |> assign(:page_title, "Edit Profile")
      |> assign(:changeset, changeset)
      |> allow_upload(:image_url,
      accept: @extension_whitelist,
      max_file_size: 9_000_000,
      progress: &handle_progress/3,
      auto_upload: true)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.current_user
      |> User.update_changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "User updated successfully")
          |> push_redirect(to: Routes.live_path(socket, InstagramWeb.UserSettingsLive))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("upload_avatar", _params, socket) do
    {:noreply, socket}
  end


  @impl true
  def handle_params(_unsigned_params, uri, socket) do
    uri_path = URI.parse(uri).path
    link1 = selected_link(uri_path, Routes.live_path(socket, InstagramWeb.UserSettingsLive))
    link2 = selected_link(uri_path, Routes.live_path(socket, InstagramWeb.UserSettingsPassLive))
    {:noreply,
      socket
      |> assign(link1: link1)
      |> assign(link2: link2)}
  end

  defp handle_progress(:image_url, entry, socket) do
    if entry.done? do
      avatar_image_url = Avatar.put_image_url(socket, entry)
      user_params = %{"image_url" => avatar_image_url}
      case Accounts.update_user(socket.assigns.current_user, user_params) do
        {:ok, _user} ->
          Avatar.update(socket, socket.assigns.current_user.image_url, entry)
          current_user = Accounts.get_user!(socket.assigns.current_user.id)
          {:noreply,
            socket
            |> put_flash(:info, "Avatar updated successfully")
            |> assign(current_user: current_user)}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      {:noreply, socket}
    end
  end

end
