defmodule AvailabitWeb.Plugs.Authorization do
  import Plug.Conn
  import Phoenix.Controller
  alias AvailabitWeb.Router.Helpers, as: RouterHelpers

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> put_flash(:error, "You need to be logged in to visit this page.")
        |> redirect(to: RouterHelpers.page_path(conn, :index))
        |> halt()
      _user ->
        conn
    end
  end
end
