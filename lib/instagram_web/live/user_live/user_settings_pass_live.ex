defmodule InstagramWeb.UserSettingsPassLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias Instagram.Uploaders.Avatar

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)
    user = socket.assigns.current_user

    {:ok,
      socket
      |> assign(:page_title, "Change Password")
      |> assign(changeset: Accounts.change_user_password(user))}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    password = Map.get(params, "current_password")
    user_params = Map.delete(params, "current_password")
    case Accounts.update_user_password(socket.assigns.current_user, password, user_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "Password updated successfully.")
          |> push_redirect(to: Routes.live_path(socket, InstagramWeb.UserSettingsPassLive))}

      {:error, changeset} ->
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
end
