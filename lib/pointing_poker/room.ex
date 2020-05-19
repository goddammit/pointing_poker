defmodule PointingPoker.Room do
  def new() do
    room_id = Base.encode16(:crypto.strong_rand_bytes(8))
    {:ok, _} =
      DynamicSupervisor.start_child(PointingPoker.Room.Supervisor,
    {PointingPoker.Room.Worker, %{room_id: room_id}}
    )
    room_id
  end

# jakby join mial byc w workerze  defdelegate join(room_pid, user_pid, username), to: PointingPoker.Room.Worker

  def join(room_pid, user_pid, username) do
    GenServer.call(room_pid, {:join, user_pid, username})

  end


  def vote(room_pid, id, vote) do
    GenServer.cast(room_pid, {:vote, id, vote })

  end

  def show_votes(room_pid, show) do
    GenServer.cast(room_pid, {:show_votes, show})

  end

end
