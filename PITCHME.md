---?image=gitpitch/cover.png
@title[Cover]

---?color=#3221a6

# Workshop Elixir Phoenix

---?color=#3221a6

## I'm Daniel
@title[Who Am I]

25 · SOFTWARE ENGINEER

FCUP, 2016
Master Degree in Network and Information Systems Engineering

---?color=#3221a6
@title[Things I Like]

## Things I Like

* Distributed Systems
* Parallel Processing
* Networks
* DevOps

---?color=#3221a6
@title[Erlang]

## Erlang

* Functional language
* Developed in 1986 by Ericsson
* Applied on telecommunications
* Distributed, fault tolerant, high availability
* Runs on the BEAM virtual machine

---?color=#3221a6
@title[What happened]

## What happened between 1986 and now

* The increased development and adoption of OOP languages
* The development of the World Wide Web
* The development of new frameworks for developing Web applications
* Huge evangelization of popular vendors languages (Java, .NET, Javascript, ...)

---?color=#3221a6
@title[Elixir]

## Elixir

* Functional Language
* Based on Erlang, runs on the BEAM VM, interoperability with Erlang code
* Big emphasis on distributed, fault-tolerant, real-time systems
* Learns from failures from previous languages
* Promotes developer happiness and faster development

---?color=#3221a6
@title[Elixir is used by]

## Elixir is used by

* WhatsApp
* Discord
* Pinterest
* Bet365
* Lonely Planet
* Bitmaker :)

---?color=#3221a6
@title[Functional Programming]

## Functional Programming

*“... a programming paradigm that treats computation as
the evaluation of mathematical functions and avoids
changing-state and mutable data.”*

<small>Functional Programming, Wikipedia</small>

---?color=#3221a6
@title[Elixir Crash Course]

# Elixir Crash Course

---?color=#3221a6
@title[Elixir Crash Course - Atom]

```
:ok, :daniel, :bitmaker
```
**Atom**

Atoms are constants where their name is their own value.

---?color=#3221a6
@title[Elixir Crash Course - Map]

```
%{name: “Daniel Silva”, age: 24}
%{“name” => “Daniel Silva”, “age” => 24}
```
**Map**

Basic key-value store, like a dictionary. Key can be atoms or strings.

---?color=#3221a6
@title[Elixir Crash Course - List]

```
[“Daniel”, “Silva”]
[1,2,3,4,5]
[:ok, :error, :warning]
```
**List**

Ordered collection of elements.

---?color=#3221a6
@title[Elixir Crash Course - Keyword List]

```
[first_name: “Daniel”, last_name: “Silva”]
[{:first_name, “Daniel”}, {:last_name, “Silva”}]
```
**Keyword List**

Ordered collection of key-value tuples.

---?color=#3221a6
@title[Elixir Crash Course - Function]

```
def my_function(param) do
  ...
end
```
**Function**

+++?color=#3221a6
@title[Elixir Crash Course - Function]

```
def my_function(param \\ %{}) do
  ...
end
```
**Function**

+++?color=#3221a6
@title[Elixir Crash Course - Function]

```
def my_function(%{my_name: name}) do
  ...
end
```
**Function**

+++?color=#3221a6
@title[Elixir Crash Course - Function]

```
def my_function(%{my_name: name} = param) do
  ...
end
```
**Function**

---?color=#3221a6
@title[Elixir Crash Course - If]

```
if user.role == “admin” do
  ...
end
```
**If**

Conditional flow control.

---?color=#3221a6
@title[Elixir Crash Course - Case]

```
case user.role do
  "admin" -> [Process admin role]
  "moderator" -> [Process moderator role]
  "user" -> [Process user role]
  other -> [Process others not matched before]
end
```
**Case**

Conditional flow control.

---?color=#3221a6
@title[Elixir Crash Course - Cond]

```
cond do
  user.age < 18 -> [...]
  user.age >= 18 and user.age <= 25 -> [...]
  true -> [...]
end
```
**Cond**

Conditional flow control.

---?color=#3221a6
@title[Phoenix Framework]

# Phoenix Framework

---?color=#3221a6
@title[Phoenix Framework]

## Phoenix Framework

* Web development framework
* Model, View, Controller
* Built on top of a collection of different open source projects - Plug, Ecto, Cowboy, ...
* High performance, high productivity
* The secret sauce are channels (WebSockets)

---?color=#3221a6
@title[Phoenix Framework]

## Phoenix Framework

* Request from client
* Router knows what function to call in the controller
* The controller function handles the request
* MAGIC!
* The controller function produces a response
* View functions build the actual response

---?color=#3221a6
@title[Availabit]

## Availabit

![Availabit](gitpitch/availabit.png)

---?color=#3221a6
@title[Availabit]

## Availabit

* Event planning web application.
* Users can register and login through GitHub.
* Users can create, edit, view and delete events.
* Users can mark the days in an event calendar and updates are broadcasted to all other users via WebSockets.

---?color=#3221a6
@title[Availabit]

## Availabit

* Users
  * Name
  * Email
  * Avatar
  
+++?color=#3221a6
@title[Availabit]

## Availabit

* Event
  * Name
  * Location
  * User who created the event
  
+++?color=#3221a6
@title[Availabit]

## Availabit

* Event Entries
  * Slots
  * Event
  * User
  
---?color=#3221a6
@title[Demo]

# Demo

---?image=gitpitch/cover.png
@title[Institutional]

---?image=gitpitch/cover2.png
@title[Institutional]
<br><br><br><br><br><br><br>
https://www.wearebitmaker.com/bitmaker-culture-book/
