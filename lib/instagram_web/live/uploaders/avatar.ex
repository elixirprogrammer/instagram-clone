defmodule Instagram.Uploaders.Avatar do
  alias InstagramWeb.Router.Helpers, as: Routes

  @upload_directory "/uploads/"

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def put_image_url(socket, entry) do
    Routes.static_path(socket, "#{@upload_directory}#{entry.uuid}.#{ext(entry)}")
  end

  def update(socket, old_url, entry) do
    Phoenix.LiveView.consume_uploaded_entry(socket, entry, fn %{} = meta ->
      dest = Path.join("priv/static/uploads", "#{entry.uuid}.#{ext(entry)}")
      dest_profile_thumb = Path.join("priv/static/uploads", "profile_thumb_#{entry.uuid}.#{ext(entry)}")
      dest_thumb = Path.join("priv/static/uploads", "thumb_#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
      mogrify_thumbnail(dest, dest_profile_thumb, 300)
      mogrify_thumbnail(dest, dest_thumb, 150)
    end)

    rm_file(old_url)
    old_url |> get_thumb() |> rm_file()
    old_url |> get_profile_thumb() |> rm_file()

    :ok
  end

  def get_thumb(old_url) do
    path = String.replace_leading(old_url, "/uploads/", "")
    [@upload_directory, "thumb_#{path}"] |> Path.join()
  end

  def get_profile_thumb(old_url) do
    path = String.replace_leading(old_url, "/uploads/", "")
    [@upload_directory, "profile_thumb_#{path}"] |> Path.join()
  end

  def rm_file(url) do
    File.rm!("priv/static/#{url}")
  end

  defp mogrify_thumbnail(src_path, dst_path, size) do
    try do
      Mogrify.open(src_path)
      |> Mogrify.resize_to_limit("#{size}x#{size}")
      |> Mogrify.save(path: dst_path)
    rescue
      File.Error -> {:error, :invalid_src_path}
      error -> {:error, error}
    else
      _image -> {:ok, dst_path}
    end
  end

end
