defmodule PointingPokerWeb.RoomController do

  use PointingPokerWeb, :controller

    def index(conn = %Plug.Conn{}, params) do

       render(conn, :index)
    end
end
