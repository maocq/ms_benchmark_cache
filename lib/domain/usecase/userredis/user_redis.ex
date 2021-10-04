defmodule Fua.UseCase.UserRedis do
  alias Fua.Model.User
  alias Fua.Model.Error

  @user_cache Application.compile_env(:fua, :user_cache_redis, Fua.Domain.Behaviour.UserCache)

  def set(%User{} = user) do
    {:ok, user}
  end

  @spec get(String.t()) :: {:ok, User.t()} | {:error, Error.t()} | {:error, term}
  def get(id) do
    case @user_cache.get(id) do
      {:ok, nil} -> {:error, %Error{error: :not_found_user, message: "Not found user #{id}"}}
      x -> x
    end
  end
end
