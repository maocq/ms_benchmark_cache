defmodule Fua.Model.User do
  @derive [Poison.Encoder]

  defstruct [
    :id,
    :name
  ]
  @type t() :: %__MODULE__{id: number, name: String.t()}
end
