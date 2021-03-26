defmodule InstagramWeb.UserProfileLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Feed.Post

  def mount(%{"username" => username}, session, socket) do
    socket = assign_defaults(session, socket)
    case Accounts.profile(username) do
      nil ->
        {:ok, socket |> push_redirect(to: "/")}
      user ->
        {:ok, assign(socket, user: user)}
    end
  end

  def link_body(_post) do
    "hello"
  end

end
