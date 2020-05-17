defmodule PointingPoker.Room do
  use GenServer

  def start_link(%{room_id: room_id} = opts) do
    GenServer.start_link(__MODULE__, opts, name: {:via, Registry, {Registry.Rooms, room_id, nil}})
  end

  @impl GenServer
  def init (%{room_id: room_id}) do
    {:ok, %{
      room_id: room_id,
      user_list: [],
      }}
  end

  @impl true
  def handle_call({:join, username, pid}, _from, state) do
    ref = Process.monitor(pid)
    joined_member =%{
      username: username,
      pid: pid,
      vote: nil}
    users = state.user_list
    state = %{state | user_list: [{username, pid} | users]}
    Enum.each(users, fn {_id, member} ->
      send(member.pid, {:joined, ref, joined_member})
    end)
    IO.inspect({self(), state})
    {:reply, state.user_list, state}

  end

end
