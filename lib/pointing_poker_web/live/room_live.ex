defmodule PointingPokerWeb.RoomLive do
  use PointingPokerWeb, :live_view

  @impl true

  def mount(params, session, socket) do
    room_id = params["room_id"]
    case Registry.lookup(Registry.Rooms, room_id) do
      [{pid, _meta}] ->
        {:ok, assign(socket, [user: nil]
        )}
      [] ->
        {:ok, assign(socket, [
          error: :no_room])}
    end

  end

  @impl true
  def render(%{error: :no_room} = assigns) do
    ~L"""
    No room
    """
  end


  @impl true
  def render(%{user: nil} = assigns) do
    Phoenix.View.render(PointingPokerWeb.RoomView, "join.html", assigns )
  end


  @impl true

  def render(%{} = assigns) do
    Phoenix.View.render(PointingPokerWeb.RoomView, "vote.html", assigns )
  end

  @impl true

  def handle_event("join", data, socket) do
    {:noreply, assign(socket, user: data["username"])}
  end

  def handle_event(event_name, data, socket) do
    IO.inspect({event_name, data})
    {:noreply, assign(socket,
    user: data["username"]

    )}
  end

  def handle_info(data, socket) do
    {:noreply, socket}
  end


end
