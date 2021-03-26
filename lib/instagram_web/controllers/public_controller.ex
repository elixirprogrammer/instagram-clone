defmodule InstagramWeb.PublicController do
  use InstagramWeb, :controller

  def homepage(conn, _params) do
    render(conn, "homepage.html")
  end
end
