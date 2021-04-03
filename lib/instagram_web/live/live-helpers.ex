defmodule InstagramWeb.LiveHelpers do
  import Phoenix.LiveView
  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias InstagramWeb.UserAuth

  def assign_defaults(session, socket) do
    if connected?(socket), do: InstagramWeb.Endpoint.subscribe(UserAuth.pubsub_topic())

    socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
      end)
    socket
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end

  def selected_link(current_uri, menu_link) when current_uri == menu_link do
    "border-l-2 border-black -ml-0.5 text-gray-900 font-semibold"
  end
  def selected_link(_current_uri, _menu_link) do
    "hover:border-l-2 -ml-0.5 hover:border-gray-300 hover:bg-gray-50"
  end
end
