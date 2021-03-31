defmodule InstagramWeb.UserSettingsLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias Instagram.Uploaders.Avatar

  @extension_whitelist ~w(.jpg .jpeg .png)


  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    user_change = socket.assigns.current_user.username

    {:ok,
      socket
      |> assign(:user_change, user_change)
      |> assign(:show_avatar, "block")
      |> assign(:show_preview_avatar, "hidden")
      |> assign(:temporary_assigns, [user_change: []])
      |> allow_upload(:image_url,
      accept: @extension_whitelist,
      max_file_size: 9_000_000)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    changeset = User.update_changeset(socket.assigns.current_user, %{})

    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.current_user
      |> User.update_changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset, show_avatar: "hidden", show_preview_avatar: "block")}
  end

  @impl true
  def handle_event("update_username", %{"value" => username}, socket) do
    {:noreply, update(socket, :user_change, fn _ -> username end)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    user_params = Avatar.put_image_url(socket, :image_url, user_params)
    case Accounts.update_user(socket.assigns.current_user, user_params) do
      {:ok, _user} ->
        Avatar.update(socket, socket.assigns.current_user.image_url)
        {:noreply,
          socket
          |> put_flash(:info, "User updated successfully")
          |> push_redirect(to: "/u/settings")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

end
