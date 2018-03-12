defmodule AvailabitWeb.EventChannelTest do
  use AvailabitWeb.ChannelCase

  alias AvailabitWeb.EventChannel

  setup do
    event = Availabit.EventsTest.event_fixture()
    user = Availabit.AccountsTest.user_fixture()

    {:ok, _, socket} =
      socket("user_id", %{user: user})
      |> subscribe_and_join(EventChannel, "event:#{event.id}")

    {:ok, [socket: socket, event: event]}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to event:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
