defmodule Availabit.Repo.Migrations.CreateEventsEntries do
  use Ecto.Migration

  def change do
    create table(:events_entries) do
      add :slots, :string
      add :event_id, references(:events, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:events_entries, [:event_id])
    create index(:events_entries, [:user_id])
  end
end
