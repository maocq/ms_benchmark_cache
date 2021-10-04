defmodule Fua.DrivenAdapters.RedisUserCache do
  alias Fua.Model.User
  alias Fua.Model.Error

  @behaviour Fua.Domain.Behaviour.UserCache

  @spec get(String.t()) :: {:ok, User.t()} | {:ok, nil} | {:error, term}
  def get(id) do
    case Redix.command(:redix, ["GET", id]) do
      {:ok, user} when not is_nil(user) -> {:ok, Poison.decode!(user, as: %User{})}
      other -> other
    end
  end

  @spec set(User.t()) :: {:ok, User.t()} | {:error, term}
  def set(user) do
    with {:ok, "OK"} <- Redix.command(:redix, ["SETEX", user.id, 60, Poison.encode!(user)]) do
      {:ok, user}
    end
  end
end