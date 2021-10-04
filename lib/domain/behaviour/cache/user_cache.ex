defmodule Fua.Domain.Behaviour.UserCache do
  alias Fua.Model.User

  @callback get(String.t()) :: {:ok, User.t()} | {:ok, nil}
  @callback set(User.t()) :: {:ok, User.t()}
end