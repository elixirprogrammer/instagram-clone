defmodule InstagramWeb.PostController do
  use InstagramWeb, :controller

  alias Instagram.Accounts
  alias Instagram.Feed
  alias Instagram.Feed.Post


  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do

  end

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show() do

  end
end
