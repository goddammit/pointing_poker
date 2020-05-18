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
          enabled_votes: [0,1,2,3,5,8,13,21,"?"]

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
    {:ok, id, members} = PointingPoker.Room.join(socket.assigns.room_pid, self(), data["username"])
    {:noreply, assign(socket, members: members, user: %{
      id: id,
      username: data["username"]
    })}
  end

  def handle_event("vote", %{"value" => vote}, socket) do
    :ok = PointingPoker.Room.vote(socket.assigns.room_pid, socket.assigns.user.id, vote)

    {:noreply, socket}
  end

  def handle_info({:update, new_members}, socket) do
    {:noreply, assign(socket,
    members: new_members
    )}
  end

#  def handle_info({:someone_voted, username, value}, socket) do
#    {:noreply, socket}
#  end





  def handle_event(event_name, data, socket) do
    IO.inspect({event_name, data})
    {:noreply, assign(socket,
    a: data["username"]

    )}
  end

end
