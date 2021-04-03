defmodule InstagramWeb.UserSettingsPassLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Accounts.User

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok,
      socket
      |> assign(:page_title, "Change Password")}
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
