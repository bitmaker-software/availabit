defmodule Availabit.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Availabit.Accounts.User
  alias Availabit.Events.EventEntry

  schema "events" do
    field :location, :string
    field :name, :string
    belongs_to :user, User
    has_many :entries, EventEntry

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :location, :user_id])
    |> validate_required([:name, :location])
  end
end
