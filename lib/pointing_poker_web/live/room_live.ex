defmodule PointingPokerWeb.RoomLive do
  use PointingPokerWeb, :live_view

  @impl true

  def mount(params, session, socket) do
    room_id = params["room_id"]
    {:ok,
    assign(socket,
    a: "Stranger",

    )}
  end

  @impl true

  def handle_event(event_name, data, socket) do
    IO.inspect({event_name, data})
    {:noreply, assign(socket,
    a: data["username"]

    )}
  end

  def handle_info(data, socket) do
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    This does nothing
    <%= @a%>
    """

    Phoenix.View.render(PointingPokerWeb.RoomView, "join.html", assigns )
  end

end
