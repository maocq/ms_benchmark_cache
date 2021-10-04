defmodule Fua.Model.Error do
  defstruct [
    :error,
    :message
  ]
  @type t() :: %__MODULE__{error: term, message: String.t()}
end