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
      |> assign(:show_avatar, "block")
      |> assign(:show_preview_avatar, "hidden")
      |> assign(:page_title, "Edit Profile")
      |> assign(:changeset, changeset)
      |> allow_upload(:image_url,
      accept: @extension_whitelist,
      max_file_size: 9_000_000)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    show_preview_avatar = show_preview_avatar(socket.assigns.uploads.image_url.entries)
    show_avatar = show_avatar(socket.assigns.uploads.image_url.entries)
    changeset =
      socket.assigns.current_user
      |> User.update_changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply,
      socket
      |> assign(changeset: changeset)
      |> assign(show_avatar: show_avatar)
      |> assign(show_preview_avatar: show_preview_avatar)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Avatar.put_image_url(socket, :image_url, user_params)
    case Accounts.update_user(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        Avatar.update(socket, socket.assigns.current_user.image_url)
        {:noreply,
          socket
          |> assign(show_avatar: "block")
          |> assign(show_preview_avatar: "hidden")
          |> put_flash(:info, "User updated successfully")
          |> push_redirect(to: "/u/settings")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
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

  defp show_preview_avatar(image_url_entries) when image_url_entries !== [], do: "block"
  defp show_preview_avatar(_image_url_entries), do: "hidden"
  defp show_avatar(image_url_entries) when image_url_entries !== [], do: "hidden"
  defp show_avatar(_image_url_entries), do: "block"

end
