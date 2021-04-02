defmodule InstagramWeb.PostLive.New do
  use InstagramWeb, :live_view

  alias Instagram.Feed.Post
  alias Instagram.Feed
  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias Instagram.Uploaders.PostUploader

  @extension_whitelist ~w(.jpg .jpeg .png)

  @impl true
  def mount(_params, %{"user_token" => user}, socket) do
    user = Accounts.get_user_by_session_token(user)
    changeset = Post.changeset(%Post{}, %{})

    {:ok,
      socket
      |> assign(current_user: user)
      |> assign(page_title: "New Post")
      |> assign(changeset: changeset)
      |> allow_upload(:image_url,
      accept: @extension_whitelist,
      max_entries: 10,
      max_file_size: 9_000_000)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Post.changeset(%Post{}, post_params)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("cancel-entry", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image_url, ref)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    post = PostUploader.put_image_url(socket, %Post{})
    case Feed.create_post(post, post_params, socket.assigns.current_user) do
      {:ok, post} ->
        PostUploader.create(socket, post)
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: "/profile/#{socket.assigns.current_user.username}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
