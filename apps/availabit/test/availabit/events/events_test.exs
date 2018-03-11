defmodule Availabit.EventsTest do
  use Availabit.DataCase

  alias Availabit.Events

  describe "events" do
    alias Availabit.Events.Event

    @valid_attrs %{location: "some location", name: "some name"}
    @update_attrs %{location: "some updated location", name: "some updated name"}
    @invalid_attrs %{location: nil, name: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture() |> Repo.preload([entries: :user])
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Events.create_event(@valid_attrs)
      assert event.location == "some location"
      assert event.name == "some name"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Events.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.location == "some updated location"
      assert event.name == "some updated name"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture() |> Repo.preload([entries: :user])
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end

  describe "events_entries" do
    alias Availabit.Events.EventEntry

    @valid_attrs %{slots: "some slots"}
    @update_attrs %{slots: "some updated slots"}
    @invalid_attrs %{slots: nil}

    def event_entry_fixture(attrs \\ %{}) do
      {:ok, event_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Events.create_event_entry()

      event_entry
    end

    test "list_events_entries/0 returns all events_entries" do
      event_entry = event_entry_fixture()
      assert Events.list_events_entries() == [event_entry]
    end

    test "get_event_entry!/1 returns the event_entry with given id" do
      event_entry = event_entry_fixture()
      assert Events.get_event_entry!(event_entry.id) == event_entry
    end

    test "create_event_entry/1 with valid data creates a event_entry" do
      assert {:ok, %EventEntry{} = event_entry} = Events.create_event_entry(@valid_attrs)
      assert event_entry.slots == "some slots"
    end

    test "create_event_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event_entry(@invalid_attrs)
    end

    test "update_event_entry/2 with valid data updates the event_entry" do
      event_entry = event_entry_fixture()
      assert {:ok, event_entry} = Events.update_event_entry(event_entry, @update_attrs)
      assert %EventEntry{} = event_entry
      assert event_entry.slots == "some updated slots"
    end

    test "update_event_entry/2 with invalid data returns error changeset" do
      event_entry = event_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event_entry(event_entry, @invalid_attrs)
      assert event_entry == Events.get_event_entry!(event_entry.id)
    end

    test "delete_event_entry/1 deletes the event_entry" do
      event_entry = event_entry_fixture()
      assert {:ok, %EventEntry{}} = Events.delete_event_entry(event_entry)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event_entry!(event_entry.id) end
    end

    test "change_event_entry/1 returns a event_entry changeset" do
      event_entry = event_entry_fixture()
      assert %Ecto.Changeset{} = Events.change_event_entry(event_entry)
    end
  end
end
