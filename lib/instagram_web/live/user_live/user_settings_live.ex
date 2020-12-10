defmodule InstagramWeb.UserSettingsLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Accounts.User

  @impl true
  def mount(_params, %{"user_token" => user}, socket) do
    user = Accounts.get_user_by_session_token(user)
    user_change = user.username

    {:ok,
      socket
      |>assign(:user, user)
      |>assign(:user_change, user_change)
      |>assign(:temporary_assigns, [user_change: []])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    changeset = User.update_changeset(socket.assigns.user, %{})

    socket
    |> assign(:page_title, "Edit Profile")
    |> assign(:changeset, changeset)
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> User.update_changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("update_username", %{"value" => username}, socket) do
    {:noreply, update(socket, :user_change, fn _ -> username end)}
  end

  @impl true
  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
          socket
          |> put_flash(:info, "User updated successfully")
          |> push_redirect(to: "/u/settings")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
