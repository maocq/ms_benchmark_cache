defmodule Fua.UseCase.UserDynamodbUseCase do
  alias Fua.Model.Error
  alias Fua.Model.User

  @user_cache Application.compile_env(:fua, :user_cache_dynamodb, Fua.Domain.Behaviour.UserCache)

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

end
