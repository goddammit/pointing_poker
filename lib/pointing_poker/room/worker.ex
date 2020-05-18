defmodule PointingPoker.Room.Worker do
  use GenServer

  def start_link(%{room_id: room_id} = opts) do
    GenServer.start_link(__MODULE__, opts, name: {:via, Registry, {Registry.Rooms, room_id, nil}})
  end

  @impl GenServer
  def init (%{room_id: room_id}) do
    {:ok, %{
      room_id: room_id,
      members: %{}
      }}
  end

  @impl GenServer
  def handle_call({:join, pid, username}, _from, state) do
    ref = Process.monitor(pid)

    joined_member= %{
        username: username,
        pid: pid,
        vote: nil
        }
    new_members = Map.put(state.members, ref, joined_member)

    Enum.each(new_members, fn {_id, member} ->
      send(member.pid, {:update, new_members})
    end)
    {:reply, {:ok, ref, new_members}, %{state | members: new_members}}

  end

  def handle_cast({:vote, id, incoming_vote}, state) do
    new_state = update_in(state.members[id].vote, fn _ -> incoming_vote end)
    Enum.each(new_state.members, fn {_id, member} ->
      send(member.pid, {:update, new_state.members})
    end)
    {:noreply, new_state}

  end


  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    new_members =
      Map.delete(state.members, ref)

    Enum.each(new_members, fn {_id, member} ->
        send(member.pid, {:update, ref, new_members})
      end)

  {:noreply, %{state | members: new_members}}
  end


end
