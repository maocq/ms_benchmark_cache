defmodule Fua.Model.User do
  defstruct [
    :id,
    :name
  ]
  @type t() :: %__MODULE__{id: number, name: String.t()}
end
