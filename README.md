# Availabit

Simple application to demo Elixir and Phoenix. It is a simple group planning application where people can login via GitHub OAuth, create new events and state the days of the week they would attend the event. The calendar is updated via WebSockets (Phoenix Channels and Phoenix Presence).

## Setup

* [Create an OAuth app](https://github.com/settings/developers) in your GitHub account and save the *Client ID* and *Client Secret*.
* Get the Elixir dependencies with `mix deps.get`.
* Get the Node dependencies with `cd apps/availabit_web/assets` and `npm install`. After that, go back to the root folder of the project (`cd ../../..`).
* Create the database with `mix ecto.create` and run the migrations with `mix ecto.migrate`.

## Running

* Start the application with `GITHUB_CLIENT_ID=<your_client_id> GITHUB_CLIENT_SECRET=<your_client_secret> iex -S mix phx.server`.

## Testing

* You can run the unit tests with `mix test`.

## License

[MIT](https://github.com/bitmaker-software/availabit/blob/master/LICENSE)
