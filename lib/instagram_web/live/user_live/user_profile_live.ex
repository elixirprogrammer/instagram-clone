defmodule InstagramWeb.UserProfileLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Feed.Post

  def mount(%{"username" => username}, session, socket) do
    socket = assign_defaults(session, socket)
    user = Accounts.profile(username)
    {:ok, assign(socket, user: user)}
  end

end
