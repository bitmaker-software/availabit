defmodule AvailabitWeb.PageController do
  use AvailabitWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
