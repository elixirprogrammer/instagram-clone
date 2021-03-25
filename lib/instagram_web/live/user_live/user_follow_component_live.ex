defmodule InstagramWeb.UserFollowComponentLive do
  use InstagramWeb, :live_component

  def render(assigns) do
    ~L"""
      <button phx-target="<%= @myself %>" phx-click="toggle-status" class="btn <%= @btn %>"><%= @name %></button>
    """
  end

  def handle_event("toggle-status", _params, socket) do
    name = if socket.assigns.name == "Follow", do: "Following", else: "Follow"
    btn = if socket.assigns.btn == "btn-primary", do: "btn-secondary", else: "btn-primary"
    :timer.sleep(200)
    {:noreply, assign(socket, name: name, btn: btn)}
  end

end
