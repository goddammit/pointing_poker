defmodule PointingPokerWeb.RoomController do

  use PointingPokerWeb, :controller


  def new(conn, _params) do
    room_id = Base.encode16(:crypto.strong_rand_bytes(8))

    {:ok, _} =
      DynamicSupervisor.start_child(PointingPoker.Room.Supervisor,
    {PointingPoker.Room, %{room_id: room_id}}
    )

    redirect(conn, to: "/room/#{room_id}" )
  end




end
