defmodule PointingPokerWeb.RoomController do

  use PointingPokerWeb, :controller


  def new(conn, _params) do
    room_id = Base.encode16(:crypto.strong_rand_bytes(8))
    
    redirect(conn, to: "/room/#{room_id}" )
  end




end
