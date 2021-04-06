defmodule Instagram.Uploaders.PostUploader do
  alias InstagramWeb.Router.Helpers, as: Routes
  alias Instagram.Feed.Post

  @upload_directory "/uploads/"

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def put_image_url(socket, %Post{} = post) do
    {completed, []} = Phoenix.LiveView.uploaded_entries(socket, :image_url)
    urls =
      for entry <- completed do
        Routes.static_path(socket, "#{@upload_directory}#{entry.uuid}.#{ext(entry)}")
      end

    %Post{post | image_url: urls}
  end

  def create(socket, %Post{} = post) do
    Phoenix.LiveView.consume_uploaded_entries(socket, :image_url, fn meta, entry ->
      dest = Path.join("priv/static#{@upload_directory}", "#{entry.uuid}.#{ext(entry)}")
      dest_post_thumb = Path.join("priv/static#{@upload_directory}", "post_thumb_#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
      mogrify_resize(dest, dest_post_thumb, "500x500")
    end)

    {:ok, post}
  end

  def get_thumb(old_url) do
    path = String.replace_leading(old_url, "/uploads/", "")
    [@upload_directory, "post_thumb_#{path}"] |> Path.join()
  end

  defp mogrify_resize(src_path, dst_path, size) do
    try do
      Mogrify.open(src_path)
      |> Mogrify.resize_to_limit(size)
      |> Mogrify.save(path: dst_path)
    rescue
      File.Error -> {:error, :invalid_src_path}
      error -> {:error, error}
    else
      _image -> {:ok, dst_path}
    end
  end

  def rm_file(url) do
    File.rm!("priv/static/#{url}")
  end

end
