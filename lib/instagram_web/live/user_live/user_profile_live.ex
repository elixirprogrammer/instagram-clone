defmodule InstagramWeb.UserProfileLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Feed.Post

  def mount(%{"username" => username}, _session, socket) do
    IO.inspect socket.assigns
    case Accounts.profile(username) do
      nil ->
        {:ok, socket |> push_redirect(to: "/")}
      user ->
        {:ok, assign(socket, user: user)}
    end
  end

end
