defmodule Instagram.Uploaders.Avatar do
  alias InstagramWeb.Router.Helpers, as: Routes

  defp ext(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    ext
  end

  def put_image_url(socket, url_name, user_params) do
    {completed, []} = Phoenix.LiveView.uploaded_entries(socket, url_name)
    urls =
      for entry <- completed do
        Routes.static_path(socket, "/uploads/#{entry.uuid}.#{ext(entry)}")
      end

    Map.put_new(user_params, Atom.to_string(url_name), List.to_string(urls))
  end

  def update(socket, old_url) do
    Phoenix.LiveView.consume_uploaded_entries(socket, :image_url, fn meta, entry ->
      dest = Path.join("priv/static/uploads", "#{entry.uuid}.#{ext(entry)}")
      File.cp!(meta.path, dest)
    end)

    rm_file(old_url)

    :ok
  end

  def rm_file(url) do
    File.rm!("priv/static/#{url}")
  end

end
