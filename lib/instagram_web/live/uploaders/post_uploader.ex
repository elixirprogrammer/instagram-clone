defmodule Instagram.Uploaders.PostUploader do
  alias InstagramWeb.Router.Helpers, as: Routes
  alias Instagram.Feed.Post

  @upload_folder_name "uploads"

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def put_image_url(socket, %Post{} = post) do
    {completed, []} = Phoenix.LiveView.uploaded_entries(socket, :image_url)
    urls =
      for entry <- completed do
        Routes.static_path(socket, "/#{@upload_folder_name}/#{entry.uuid}.#{ext(entry)}")
      end

    %Post{post | image_url: urls}
  end

  def create(socket, %Post{} = post) do
    Phoenix.LiveView.consume_uploaded_entries(socket, :image_url, fn meta, entry ->
      dest = Path.join("priv/static/#{@upload_folder_name}", "#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
    end)

    {:ok, post}
  end

  def rm_file(url) do
    File.rm!("priv/static/#{url}")
  end

end
