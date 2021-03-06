defmodule Fua.DrivenAdapters.RedisUserCache do
  alias Fua.Model.User

  @behaviour Fua.Domain.Behaviour.UserCache

  @expiration_time_seconds 900

  @spec get(String.t()) :: {:ok, User.t()} | {:ok, nil}
  def get(id) do
    with {:ok, json} when not is_nil(json) <- Redix.command(:redix, ["GET", id]),
         {:ok, user} <- Poison.decode(json, as: %User{}), do: {:ok, user}
  end

  @spec set(User.t()) :: {:ok, User.t()}
  def set(user) do
    with {:ok, json} <- Poison.encode(user),
         {:ok, "OK"} <- Redix.command(:redix, ["SETEX", user.id, @expiration_time_seconds, json]) do
      {:ok, user}
    end
  end
end