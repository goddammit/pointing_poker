defmodule PointingPokerWeb.RoomController do

  use PointingPokerWeb, :controller
  use GenServer


  def index(conn, _params) do
    redirect(conn, to: "/#{:rand.uniform(200)}" )
  end




end
