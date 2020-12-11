defmodule InstagramWeb.UserProfileLive do
  use InstagramWeb, :live_view

  def mount(%{"username" => username}, _session, socket) do
    case check_username_param(username) do
      nil ->
        {:ok, socket |> push_redirect(to: "/")}
      username ->
        {:ok, socket}
    end
  end

  defp check_username_param(username) do
    Regex.run(~r/^[a-zA-Z0-9_.-]*$/, username)
  end
end
