defmodule PointingPokerWeb.RoomLive do
  use PointingPokerWeb, :live_view

  @impl true

  def mount(params, session, socket) do
    room_id = params["room_id"]
    case Registry.lookup(Registry.Rooms, room_id) do
      [{pid, _meta}] ->
        {:ok, assign(socket, [
          user: nil,
          room: pid,
          members: %{},
          enabled_votes: [1,2,3,5,8,13]
        ]
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
    user_list = GenServer.call(socket.assigns[:room], {:join, data["username"], self()})
    {:noreply, assign(socket, user: data["username"], user_list: user_list)}
  end

  def handle_event("vote", data, socket) do
    GenServer.call(socket.assigns[:room], {:vote, data["value"] })
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
#  def handle_info({:someone_voted, username, value}, socket) do
#    {:noreply, socket}
#  end

#  def handle_info(data, socket) do
#    new_members = Map.put(socket.assigns[:members], username, value)
#    {:noreply, assign(socket,
#    members: new_members

#  end


end
