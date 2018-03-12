defmodule AvailabitWeb.EventChannel do
  use AvailabitWeb, :channel
  alias AvailabitWeb.Presence
  alias Availabit.Events
  alias Phoenix.Socket

  def join("event:" <> event_id, payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, Socket.assign(socket, :event_id, event_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
    broadcast_entries(socket)

    push socket, "presence_state", Presence.list(socket)
    {:ok, _} = Presence.track(socket, socket.assigns.user.id, %{
      user: socket.assigns.user,
      online_at: inspect(System.system_time(:seconds))
    });

    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("entry-update", %{"slots" => slots}, socket) do
    %Socket{assigns: %{user: user, event_id: event_id}} = socket

    attrs = %{
      slots: Poison.encode!(slots),
      event_id: event_id,
      user_id: user.id
    }

    case Events.create_or_update_entry(attrs) do
      {:ok, _event_entry} -> broadcast_entries(socket)
      {:error, _changeset} -> :noop
    end

    {:noreply, socket}
  end

  defp authorized?(_payload) do
    true
  end

  defp broadcast_entries(%Socket{assigns: %{event_id: event_id}} = socket) do
    event = Events.get_event!(event_id)
    broadcast socket, "entries", %{entries: event.entries}
  end
end
