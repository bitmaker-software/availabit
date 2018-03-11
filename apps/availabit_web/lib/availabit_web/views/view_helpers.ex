defmodule AvailabitWeb.ViewHelpers do
  @moduledoc """
  Common helper functions for templates.
  """
  
  def get_authenticated_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end
end
