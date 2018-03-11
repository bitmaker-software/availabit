defmodule AvailabitWeb.AuthController do
  use AvailabitWeb, :controller
  alias Availabit.Accounts

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate with GitHub.")
    |> redirect(to: page_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: %{info: info}}} = conn, _params) do
    case Accounts.get_or_create_user(info) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user, user)
        |> redirect(to: page_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong registering the user.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end
