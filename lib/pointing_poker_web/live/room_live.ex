defmodule PointingPokerWeb.RoomLive do
  use PointingPokerWeb, :live_view

  @impl true

  def mount(params, session, socket) do
    room_id = params["room_id"]
    case Registry.lookup(Registry.Rooms, room_id) do
      [{pid, _meta}] ->
        {:ok, assign(socket,
          user: nil,
          room_pid: pid,
          members: %{},
          enabled_votes: [1,2,3,5,8,13,21,"?"]

        )}
      [] ->
        {:ok, assign(socket, [
          error: :no_room
          ])}
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
    {:ok, id, members} = GenServer.call(socket.assigns[:room_pid], {:join, self(), data["username"]})
    {:noreply, assign(socket, members: members, user: %{
      id: id,
      username: data["username"]
    })}
  end

  def handle_event("vote", data, socket) do
    GenServer.call(socket.assigns[:room_pid], {:vote, socket.assigns[:room_pid], data["value"] })
    {:noreply, assign(socket, user: data["username"])}
  end

  def handle_event(event_name, data, socket) do
    IO.inspect({event_name, data})
    {:noreply, assign(socket,
    a: data["username"]

    )}
  end

  def handle_info({:joined, id, member}, socket) do
    new_members = Map.put(socket.assigns.members, id, member)
    {:noreply, assign(socket,
    members: new_members
    )}
  end

  def handle_info({:left, id}, socket) do
    new_members = Map.delete(socket.assigns.members, id)
    {:noreply, assign(socket,
    members: new_members
    )}
  end
#  def handle_info({:someone_voted, username, value}, socket) do
#    {:noreply, socket}
#  end

  def handle_info({:someone_voted, username, value}, socket) do
    new_members = Map.put(socket.assigns.members, username, value)
    {:noreply, assign(socket,
    members: new_members
    )}

  end


end
