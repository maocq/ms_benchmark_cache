defmodule Fua.Model.CastServer do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({mod, fun, params}, state) do
    apply(mod, fun, params)
    {:noreply, state}
  end

  def cast({mod, fun, params}), do: GenServer.cast(__MODULE__, {mod, fun, params})
end
