defmodule PointingPokerWeb.RoomController do

  use PointingPokerWeb, :controller


  def new(conn, _params) do
    room_id = PointingPoker.Room.new()
    redirect(conn, to: "/room/#{room_id}" )
  end




end
