defmodule Instagram.HeaderComponentLive do
  use InstagramWeb, :live_component

  alias Instagram.Accounts

  def mount(_params, %{"user_token" => user}, socket) do
    user = Accounts.get_user_by_session_token(user)
    {:ok, assign(socket, :current_user, user)}
  end

  def render(assigns) do
    ~L"""
    """
  end
end
