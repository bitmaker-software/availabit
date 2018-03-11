defmodule AvailabitWeb.EventControllerTest do
  use AvailabitWeb.ConnCase

  alias Availabit.Events

  @create_attrs %{location: "some location", name: "some name"}
  @update_attrs %{location: "some updated location", name: "some updated name"}
  @invalid_attrs %{location: nil, name: nil}

  def fixture(:event) do
    {:ok, event} = Events.create_event(@create_attrs)
    event
  end

  describe "index" do
    setup [:authenticate_user]

    test "lists all events", %{conn: conn} do
      conn = get conn, event_path(conn, :index)
      assert html_response(conn, 200)
    end
  end

  describe "new event" do
    setup [:authenticate_user]

    test "renders form", %{conn: conn} do
      conn = get conn, event_path(conn, :new)
      assert html_response(conn, 200)
    end
  end

  describe "create event" do
    setup [:authenticate_user]

    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == event_path(conn, :show, id)

      conn = get conn, event_path(conn, :show, id)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, event_path(conn, :create), event: @invalid_attrs
      assert html_response(conn, 200)
    end
  end

  describe "edit event" do
    setup [:create_event, :authenticate_user]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get conn, event_path(conn, :edit, event)
      assert html_response(conn, 200)
    end
  end

  describe "update event" do
    setup [:create_event, :authenticate_user]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @update_attrs
      assert redirected_to(conn) == event_path(conn, :show, event)

      conn = get conn, event_path(conn, :show, event)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put conn, event_path(conn, :update, event), event: @invalid_attrs
      assert html_response(conn, 200)
    end
  end

  describe "delete event" do
    setup [:create_event, :authenticate_user]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete conn, event_path(conn, :delete, event)
      assert redirected_to(conn) == event_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, event_path(conn, :show, event)
      end
    end
  end

  defp authenticate_user(%{conn: conn}) do
    {:ok, user} = Availabit.Accounts.create_user(%{name: "John Doe", email: "john@test.com", avatar: "http://randomimage.png"})
    conn = Plug.Test.init_test_session(conn, %{user: user})
    {:ok, conn: conn}
  end

  defp create_event(_) do
    event = fixture(:event)
    {:ok, event: event}
  end
end
