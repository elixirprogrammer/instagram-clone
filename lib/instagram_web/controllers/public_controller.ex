defmodule InstagramWeb.PublicController do
  use InstagramWeb, :controller

  alias Instagram.Accounts
  alias Instagram.Accounts.Public

  def homepage(conn, _params) do
    render(conn, "homepage.html")
  end
end
