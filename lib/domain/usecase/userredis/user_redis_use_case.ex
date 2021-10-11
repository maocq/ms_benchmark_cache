defmodule Fua.UseCase.UserRedisUseCase do
  alias Fua.Model.CastServer
  alias Fua.Model.Error
  alias Fua.Model.User

  @user_cache Application.compile_env(:fua, :user_cache_redis, Fua.Domain.Behaviour.UserCache)

  @spec get(String.t()) :: {:ok, User.t()} | {:error, Error.t()}
  def get(id) do
    case @user_cache.get(id) do
      {:ok, nil} -> {:error, %Error{error: :not_found_user, message: "Not found user #{id}"}}
      x -> x
    end
  end

  @spec set(User.t()) :: {:ok, User.t()}
  def set(%User{} = user) do
    @user_cache.set(user)
  end



  @spec get_set(User.t()) :: {:ok, User.t()}
  def get_set(%User{} = user) do
    with {:ok, _user_or_nil} <- @user_cache.get(user.id),
         {:ok, new_user} <- set(user) do
      {:ok, new_user}
    end
  end

  @spec get_set_process(User.t()) :: {:ok, User.t()}
  def get_set_process(%User{} = user) do
    with {:ok, _user_or_nil} <- @user_cache.get(user.id),
         _pid <- spawn(__MODULE__, :set, [user]) do
      {:ok, user}
    end
  end

  @spec get_set_cast(User.t()) :: {:ok, User.t()}
  def get_set_cast(%User{} = user) do
    with {:ok, _user_or_nil} <- @user_cache.get(user.id),
         _ok <- CastServer.cast({__MODULE__, :set, [user]}) do
      {:ok, user}
    end
  end

end
