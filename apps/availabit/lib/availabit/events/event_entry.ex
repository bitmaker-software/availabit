defmodule Availabit.Events.EventEntry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Availabit.Events.Event
  alias Availabit.Accounts.User

  schema "events_entries" do
    field :slots, :string
    belongs_to :event, Event
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(event_entry, attrs) do
    event_entry
    |> cast(attrs, [:slots, :event_id, :user_id])
    |> validate_required([:slots])
  end
end
