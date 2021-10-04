defmodule Fua.UseCase.UserDynamodbUseCase do
  alias Fua.Model.User

  def get(id) do
    {:ok, %User{id: id, name: "S"}}
  end

  def set(%User{} = user) do
    {:ok, user}
  end

end
