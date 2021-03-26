defmodule InstagramWeb.UserPostLive do
  use InstagramWeb, :live_view

  alias Instagram.Feed

  def mount(%{"id" => id}, session, socket) do
    socket = assign_defaults(session, socket)
    post = Feed.get_post!(Base.decode64!(id, padding: false))
    {:ok, assign(socket, post: post)}
  end

end
