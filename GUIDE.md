# ENEI 2018 - Elixir/Phoenix Workshop

## Useful commands

* `iex -S mix phx.server` -> Starts the development server
* `mix test` -> Runs unit tests
* `mix phx.routes` -> Show all the routes in the web application (needs to executed inside the folder of the web application - `cd apps/availabit_web`)
* `h Enum.map` -> TODO

## Step 1 - Create the project

The first step is create a new empty Phoenix project. For that, you just need to run the command:

```
mix phx.new availabit --umbrella
```

This will create a new project as an [umbrella project](https://elixirschool.com/en/lessons/advanced/umbrella-projects). The folder of our project will be called **availabit_umbrella**. You can rename it as you wish.

## Step 2 - Change database driver to SQLite (optional)

By default, the project generator will create the new Phoenix project with [Ecto](https://github.com/elixir-ecto/ecto) configured to use a PostgreSQL database. If you have PostgreSQL installed and you want to use it in this workshop, you are good to go. If you want to use a simpler alternative, you can use SQLite.

First you need to replace the PostgreSQL driver with the SQLite driver. For that, in the `apps/availabit/mix.exs` file, replace the `{:postgrex, ">= 0.0.0"}` line with `{:sqlite_ecto2, "~> 2.2"}`. After that, run `mix deps.get` to get the new dependency.

With the correct driver in our project dependencies, we just need to update the configuration files to use the SQLite adapter.

In `apps/availabit/config/dev.exs` replace:

```
config :availabit, Availabit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "availabit_dev",
  hostname: "localhost",
  pool_size: 10
```

with:

```
config :availabit, Availabit.Repo,
  adapter: Sqlite.Ecto2,
  database: "dev.sqlite3"
```

In `apps/availabit/config/prod.secret.exs` replace:

```
config :availabit, Availabit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "availabit_prod",
  pool_size: 15
```

with:

```
config :availabit, Availabit.Repo,
  adapter: Sqlite.Ecto2,
  database: "prod.sqlite3"
```

And in `apps/availabit/config/test.exs` replace:

```
config :availabit, Availabit.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "availabit_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
```

with:

```
config :availabit, Availabit.Repo,
  adapter: Sqlite.Ecto2,
  database: "test.sqlite3",
  pool: Ecto.Adapters.SQL.Sandbox
```

There are a bunch of [other database adpaters available](https://github.com/elixir-ecto/ecto#usage).

After this configuration, run the `mix ecto.create` command to create your development database.

## Step 3 - Generate database migrations, schemas, context functions, controllers, views, templates and unit tests

We can take advantage of the code generators provided by the Phoenix framework to develop faster and learn best practices. For this step we are going to use the `mix phx.gen.context` and `mix phx.gen.html` commands. The `mix phx.gen.context` will generate a schema, database migration, context functions and unit tests. The `mix phx.gen.html` will generate the same things as the `mix phx.gen.context` and a controller, a view, several templates for the CRUD functions and unit tests for the web related components.

**IMPORTANT** - To run the generators, we need to be in the `availabit_web` app folder (`cd apps/availabit_web`).

For our application, we are going to need three different models. First, we need an **User** model that stores the name, email and avatar of our users.

```
mix phx.gen.context Accounts User users name:string email:string:unique avatar:string
```

Next, we need an **Event** model to store the name, location and the ID of the user that created that event.

```
mix phx.gen.html Events Event events name:string location:string user_id:references:users
```

Don't forget to the new routes to the `apps/availabit_web/lib/availabit_web/router.ex` file before moving forward.

```
scope "/", AvailabitWeb do
  pipe_through :browser # Use the default browser stack

  get "/", PageController, :index
  resources "/events", EventController # Add this line
end
```

Finally, we need an **EventEntry** model to store the slots of the calendar and the IDs of the user and that event.

```
mix phx.gen.context Events EventEntry events_entries event_id:references:events user_id:references:users slots:string
```

After generating everything, go back the root folder of the project (`cd ../..`) and run the `mix ecto.migrate` to run the database migrations.

## Step 4 - Add authentication with GitHub

The users in our application will login using their GitHub account, via OAuth. First, we need to setup a **New OAuth App** in the [GitHub Developer settings](https://github.com/settings/developers) page. Give it any **name** you want, an homepage URL (it can be `http://0.0.0.0:4000/`) and an **authorization callback URL** (make sure it is `http://0.0.0.0:4000/auth/github/callback`). After registering your app, you are going to have a **Client ID** and a **Client Secret**. Keep these values, we are going to need them later.

In our application, to perform the authentication we are going to use the [Ueberauth](https://github.com/ueberauth/ueberauth) library. This library has [a lot of different supported authentication strategies](https://github.com/ueberauth/ueberauth/wiki/List-of-Strategies).

In the `apps/availabit_web/mix.exs` file, add the dependency:

```
{:ueberauth_github, "~> 0.7"}
```

And don't forget to run the `mix deps.get` command to get the new dependency. With the library in our project, we need to configure it. In the `apps/availabit_web/config/config.exs` file, add:

```
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "read:user,user:email"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "GITHUB_CLIENT_ID",
  client_secret: "GITHUB_CLIENT_SECRET"
```

In this configuration, replace the **GITHUB_CLIENT_ID** and **GITHUB_CLIENT_SECRET** by the values you got earlier from the OAuth application configuration in GitHub.

With the Ueberauth GitHub strategy configured, we need to implement a new controller to redirect authentication requests to GitHub and to receive the callback from GitHub with the result of the authentication process. Create the file `apps/availabit_web/lib/availabit_web/controllers/auth_controller.ex` and add:

```
defmodule AvailabitWeb.AuthController do
  use AvailabitWeb, :controller
  alias Availabit.Accounts

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate with GitHub.")
    |> redirect(to: page_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_auth: %{info: info}}} = conn, _params) do
    case Accounts.get_or_create_user(info) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:user, user)
        |> put_session(:user_token, Phoenix.Token.sign(conn, "user socket", user.id))
        |> redirect(to: page_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Something went wrong registering the user.")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def logout(conn, _params) do
    conn
    |> delete_session(:user)
    |> put_flash(:info, "Successfully logged out.")
    |> redirect(to: page_path(conn, :index))
  end
end
```

In our `auth_controller.ex` we are calling the `get_or_create_user` function, but it does not exist yet. In the `apps/availabit/lib/availabit/accounts/accounts.ex` file, add the function:

```
@doc """
Queries the database for the given `email` address. If no user is found,
creates it.

## Examples

    iex> get_or_create_user(%{field: value})
    %User{}

"""
def get_or_create_user(%{email: email} = attrs) do
  case Repo.get_by(User, %{email: email}) do
    nil ->
      attrs = Map.update!(attrs, :name, fn value ->
        case value do
          nil -> attrs.nickname
          name -> name
        end
      end)

      create_user(%{
        avatar: attrs.image,
        email: attrs.email,
        name: attrs.name,
      })
    user ->
      {:ok, user}
  end
end
```

The only thing left is to create the routes for the authentication. In the `apps/availabit_web/lib/availabit_web/router.ex` file, add:

```
scope "/auth", AvailabitWeb do
  pipe_through :browser

  get "/:provider", AuthController, :request
  get "/:provider/callback", AuthController, :callback
  delete "/logout", AuthController, :logout
end
```

## Step 5 - Authorization

Right now, we can authenticate users but there is no use for that yet, users can visit the same pages as if they were not authenticated.

First, lets create some helper functions that will be useful. Create the file `apps/availabit_web/lib/availabit_web/views/view_helpers.ex`:

```
defmodule AvailabitWeb.ViewHelpers do
  @moduledoc """
  Common helper functions for templates.
  """

  def get_authenticated_user(conn) do
    Plug.Conn.get_session(conn, :user)
  end

  def get_authenticated_user_token(conn) do
    Plug.Conn.get_session(conn, :user_token)
  end
end
```

To make these new functions available in all of our views, we need to import in in the `apps/availabit_web/lib/availabit_web.ex` file:

```
def view do
  quote do
    use Phoenix.View, root: "lib/availabit_web/templates",
                      namespace: AvailabitWeb

    # Import convenience functions from controllers
    import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

    # Use all HTML functionality (forms, tags, etc)
    use Phoenix.HTML

    import AvailabitWeb.Router.Helpers
    import AvailabitWeb.ErrorHelpers
    import AvailabitWeb.Gettext
    import AvailabitWeb.ViewHelpers # Add this line
  end
end
```

Now we are ready to create a simple Plug that on each request that received, check if the user is authenticated and allows (or not) the access. Create file `apps/availabit_web/lib/availabit_web/plugs/authorization.ex` (create the `plugs` folder as well):

```
defmodule AvailabitWeb.Plugs.Authorization do
  import Plug.Conn
  import Phoenix.Controller
  alias AvailabitWeb.Router.Helpers, as: RouterHelpers

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user) do
      nil ->
        conn
        |> put_flash(:error, "You need to be logged in to visit this page.")
        |> redirect(to: RouterHelpers.page_path(conn, :index))
        |> halt()
      _user ->
        conn
    end
  end
end
```

To use our new Plug, in the `apps/availabit_web/lib/availabit_web/router.ex` file add this new pipeline:

```
pipeline :authorization do
  plug AvailabitWeb.Plugs.Authorization
end
```

And now we can use our new pipeline in any scope that we want. Let's create a new scope for our events related endpoints and the `:authorization` plug. Be sure to create a new scope, add the same `resources "/events", EventController` line to it, and remove the old one from the previous scope.

```
scope "/", AvailabitWeb do
  pipe_through :browser # Use the default browser stack

  get "/", PageController, :index
  # Events routes removed from here
end

scope "/", AvailabitWeb do
  pipe_through [:browser, :authorization]

  resources "/events", EventController # Events routes now here
end
```

If you run your unit tests right now, you will that we just broke our tests.

```
** (RuntimeError) expected response with status 200, got: 302, with body:
     <html><body>You are being <a href="/">redirected</a>.</body></html>
```

We need to authenticate a user in our unit tests as well. Fortunatly, that is pretty easy to do. In the `apps/availabit_web/test/availabit_web/controllers/event_controller_test.exs` file add this helper function and the setup macro:

```
setup %{conn: conn} do
  [conn: authenticate_user(conn)]
end

defp authenticate_user(conn) do
  {:ok, user} = Availabit.Accounts.create_user(%{name: "John Doe", email: "john@test.com", avatar: "http://randomimage.png"})
  Plug.Test.init_test_session(conn, %{user: user})
end
```

## Step 6 - Add authenticated user ID to event on create

Another change we need to make is to add the `:user_id` field to the **Event** changeset. In `apps/availabit/lib/availabit/events/event.ex` change the changeset function to:

```
@doc false
def changeset(event, attrs) do
  event
  |> cast(attrs, [:name, :location, :user_id])
  |> validate_required([:name, :location, :user_id])
end
```

With **Event** changeset ready to receive the `:user_id` and store it in the database, we just need to make a small change to the controller. In the `apps/availabit_web/lib/availabit_web/controllers/event_controller.ex` file, change the `create` function to add the `:user_id` to the parameters passed to the `create_event` function:

```
def create(conn, %{"event" => event_params}) do
  # Add the next line
  event_params = Map.put(event_params, "user_id", AvailabitWeb.ViewHelpers.get_authenticated_user(conn).id)

  case Events.create_event(event_params) do
    {:ok, event} ->
      conn
      |> put_flash(:info, "Event created successfully.")
      |> redirect(to: event_path(conn, :show, event))
    {:error, %Ecto.Changeset{} = changeset} ->
      render(conn, "new.html", changeset: changeset)
  end
end
```

If you run the unit tests, you will see that we just broke them again. First, lets fix the tests in the `apps/availabit/test/availabit/events/events_test.exs` file by changing the `event_fixture` funtion:

```
def event_fixture(attrs \\ %{}) do
  user = Availabit.AccountsTest.user_fixture()
  {:ok, event} =
    attrs
    |> Map.put(:user_id, user.id)
    |> Enum.into(@valid_attrs)
    |> Events.create_event()

  event
end
```

And change the `create_event/1 with valid data creates a event` test:

```
test "create_event/1 with valid data creates a event" do
  user = Availabit.AccountsTest.user_fixture()
  assert {:ok, %Event{} = event} = Events.create_event(Map.put(@valid_attrs, :user_id, user.id))
  assert event.location == "some location"
  assert event.name == "some name"
end
```

Next, we just need to fix the web application tests. In the `apps/availabit_web/test/availabit_web/controllers/event_controller_test.exs` file, change the `fixture` function to:

```
def fixture(:event) do
  user = Availabit.AccountsTest.user_fixture()
  {:ok, event} = Events.create_event(Map.put(@create_attrs, :user_id, user.id))
  event
end
```

## Step 7 - Make schemas structures JSON encodable

By default, schemas structures cannot be directly encoded into JSON. The project has a default JSON encoding and decoding library called Poison and we can use that to encode our structures into JSON, we just need to tell the library how to do it.

One of the easiest and fastest ways of doing that it by adding the `@derive` property to a schema. In the `apps/availabit/lib/availabit/accounts/user.ex` file:

```
@derive {Poison.Encoder, only: [:id, :avatar, :email, :name]}
schema "users" do
  field :avatar, :string
  field :email, :string
  field :name, :string

  timestamps()
end
```

And we can do the same in the `apps/availabit/lib/availabit/events/event.ex` file:

```
@derive {Poison.Encoder, only: [:id, :location, :name, :user, :entries]}
schema "events" do
  field :location, :string
  field :name, :string
  field :user_id, :id

  timestamps()
end
```

Notice that we would like to have the `:user` field (not just the user ID but all of the user data) and an `:entries` field (that is not even defined on our schema). Ecto allows us to easily create these connections and load data easier. Change the schema to this:

```
@derive {Poison.Encoder, only: [:id, :location, :name, :user, :entries]}
schema "events" do
  field :location, :string
  field :name, :string
  belongs_to :user, Availabit.Accounts.User
  has_many :entries, Availabit.Events.EventEntry

  timestamps()
end
```

Even though we have the `:user` (not `:user_id`) defined with the `belongs_to` instead of `field`, the `belongs_to` puts both the field `:user_id` and `:user` (with the data for the user with that `:user_id`).

By default, the data of these associations are not loaded. To load them, we need to explicitly `preload` these associations. In `apps/availabit/events/events.ex`, change the `get_event!` function to:

```
def get_event!(id) do
  Event
  |> Repo.get!(id)
  |> Repo.preload([[entries: :user], :user])
end
```

Finally, we just need add the JSON encoding to the **EventEntry** schema. Another way of doing that is by implmenting the `Poison.Encoder` protocol. In the `apps/availabit/lib/availabit/events/event_entry.ex` file:

```
defmodule Availabit.Events.EventEntry do
  use Ecto.Schema
  import Ecto.Changeset


  schema "events_entries" do
    field :slots, :string
    field :event_id, :id
    belongs_to :user, Availabit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(event_entry, attrs) do
    event_entry
    |> cast(attrs, [:slots, :user_id, :event_id])
    |> validate_required([:slots])
  end

  defimpl Poison.Encoder, for: Availabit.Events.EventEntry do
    def encode(entry, options) do
      entry
      |> Map.take([:slots, :user])
      |> Map.update!(:slots, fn slots -> Poison.decode!(slots) end)
      |> Poison.Encoder.encode(options)
    end
  end
end
```

After all of these changes, there are some unit tests that we need to fix before continuing. In the `apps/availabit/test/availabit/events/events_test.exs` file replace the `get_event!/1 returns the event with given id` test:

```
test "get_event!/1 returns the event with given id" do
  event = Repo.preload(event_fixture(), [:entries, :user])
  assert Events.get_event!(event.id) == event
end
```

And replace the `update_event/2 with invalid data returns error changeset` test:

```
test "update_event/2 with invalid data returns error changeset" do
  event = event_fixture()
  assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
  assert Repo.preload(event, [:entries, :user]) == Events.get_event!(event.id)
end
```

## Step 8 - Copy templates and static assets to your project

To save time, we made available to you the templates and static assets that we need to move on. You can get a ZIP archive with the file in [this link](https://drive.google.com/file/d/1bNUcqjpTahYRYCDsc0HHXpHVozp_d04h/view?usp=sharing).

In the `apps/availabit_web/assets`, remove the `js`, `css` and `static` folders. Copy the `js`, `css` and `static` folder from the ZIP archive to the `apps/availabit_web/assets` folder.

In the `apps/availabit_web/lib/availabit_web`, delete the `templates` folder and then copy the `templates` folder from the ZIP archive to here.

We just need fix one test before moving on. In the `apps/availabit_web/test/availabit_web/controllers/page_controller_test.exs`, change the unit test to:

```
test "GET /", %{conn: conn} do
  conn = get conn, "/"
  assert html_response(conn, 200) =~ "Compare availability to find the best time for everyone to meet."
end
```

After that run the command `mix clean`.

## Step 9 - Create Event channel

For the live updates of the event calendar, we need a channel for the WebSockets connections. To create a channel, go to the web application folder (`cd apps/availabit_web`) and run the command:

```
mix phx.gen.channel Event
```

We are also going to use a library called `Presence` that allows us to keep track of the connected clients to our application.

```
mix phx.gen.presence
```

After generating the `Presence` module, we need to add it to our supervision tree. In the  `apps/availabit_web/lib/availabit_web/application.ex` file:

```
children = [
  supervisor(AvailabitWeb.Endpoint, []),
  supervisor(AvailabitWeb.Presence, []), # Add this line
]
```

After that go to the root folder of the project (`cd ../..`), in the `apps/availabit_web/lib/availabit_web/channels/user_socket.ex` file replace:

```
defmodule AvailabitWeb.UserSocket do
  use Phoenix.Socket

  channel "event:*", AvailabitWeb.EventChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"token" => token}, socket) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
     {:ok, user_id} ->
       user = Availabit.Accounts.get_user!(user_id)
       {:ok, assign(socket, :user, user)}
     {:error, _reason} ->
       :error
    end
  end

  def id(_socket), do: nil
end
```

Now, we just need to replace the generated `apps/availabit_web/lib/availabit_web/channels/event_channel.ex` with:

```
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
```

Note that we use the function `create_or_update_entry` but it does not exist yet. In the `apps/availabit/lib/availabit/events/events.ex` file, add the function:

```
@doc """
Creates or update an event_entry.

## Examples

    iex> create_or_update_entry(%{field: value})
    {:ok, %EventEntry{}}

    iex> create_or_update_entry(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

"""
def create_or_update_entry(attrs) do
  case Repo.get_by(EventEntry, %{user_id: attrs.user_id, event_id: attrs.event_id}) do
    nil ->
      create_event_entry(attrs)
    event_entry ->
      update_event_entry(event_entry, attrs)
  end
end
```

Finally, we just need to fix the unit tests that we just broke. In the `apps/availabit_web/test/availabit_web/channels/event_channel_test.exs` file, replace:

```
setup do
  event = Availabit.EventsTest.event_fixture()
  user = Availabit.AccountsTest.user_fixture(%{email: "#{inspect self()}@test.com"})

  {:ok, _, socket} =
    socket("user_id", %{user: user})
    |> subscribe_and_join(EventChannel, "event:#{event.id}")

  {:ok, [socket: socket, event: event]}
end
```
