defmodule Fua.UseCase.UserDynamodb do
  alias Fua.Model.User

  def set(%User{} = user) do
    {:ok, user}
  end

  def get(id) do
    {:ok, %User{id: id, name: "S"}}
  end
end
