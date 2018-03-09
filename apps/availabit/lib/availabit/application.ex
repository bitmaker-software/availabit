defmodule Availabit.Application do
  @moduledoc """
  The Availabit Application Service.

  The availabit system business domain lives in this application.

  Exposes API to clients such as the `AvailabitWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Availabit.Repo, []),
    ], strategy: :one_for_one, name: Availabit.Supervisor)
  end
end
