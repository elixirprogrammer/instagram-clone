defmodule InstagramWeb.UserProfileLive do
  use InstagramWeb, :live_view

  alias Instagram.Accounts
  alias Instagram.Feed.Post

  def mount(%{"username" => username}, session, socket) do
    case Accounts.profile(username) do
      nil ->
        {:ok, socket |> push_redirect(to: "/")}
      user ->
        {:ok, assign(socket, user: user)}
    end
  end

end
