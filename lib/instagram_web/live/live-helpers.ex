defmodule InstagramWeb.LiveHelpers do
  import Phoenix.LiveView
  alias Instagram.Accounts
  alias Instagram.Accounts.User
  alias InstagramWeb.Router.Helpers, as: Routes

  def assign_defaults(session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
      end)
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end
end