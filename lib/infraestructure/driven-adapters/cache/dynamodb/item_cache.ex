defmodule Fua.DrivenAdapters.Dynamodb.ItemCache do

  @derive [ExAws.Dynamo.Encodable]
  defstruct [
    :key,
    :expiration,
    :value
  ]
  @type t() :: %__MODULE__{key: String.t(), expiration: number, value: String.t()}
end
