defmodule Availabit.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Availabit.Accounts.User

  schema "events" do
    field :location, :string
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :location, :user_id])
    |> validate_required([:name, :location])
  end
end
