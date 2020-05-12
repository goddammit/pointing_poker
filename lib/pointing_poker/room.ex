defmodule PointingPoker.Room do
  use GenServer

  def start_link(%{room_id: room_id} = opts) do
    GenServer.start_link(__MODULE__, opts, name: {:via, Registry, {Registry.Rooms, room_id, nil}})
  end

  @impl GenServer
  def init (%{room_id: room_id}) do
    {:ok, %{
      room_id: room_id
      }}
  end

end
