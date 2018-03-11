defmodule AvailabitWeb.LayoutView do
  use AvailabitWeb, :view

  def get_authenticated_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end
end
