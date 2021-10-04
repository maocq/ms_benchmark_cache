defmodule Fua.DrivenAdapters.DynamodbUserCache do
  alias ExAws.Dynamo
  alias Fua.DrivenAdapters.Dynamodb.ItemCache
  alias Fua.Model.User

  @behaviour Fua.Domain.Behaviour.UserCache

  @table_name "cache"
  @expiration_time_seconds 900

  @spec get(String.t()) :: {:ok, User.t()} | {:ok, nil}
  def get(id) do
    with {:ok, response} <- Dynamo.get_item(@table_name, %{key: id}) |> ExAws.request,
         {:ok, json} when not is_nil(json) <- get_value(response),
         {:ok, user} <- Poison.decode(json, as: %User{}), do: {:ok, user}
  end

  @spec set(User.t()) :: {:ok, User.t()}
  def set(user) do
    exp = :os.system_time(:second) + @expiration_time_seconds

    with {:ok, json} <- Poison.encode(user),
         item <- %ItemCache{key: user.id, expiration: exp, value: json},
         {:ok, %{}}  <- Dynamo.put_item(@table_name, item) |> ExAws.request do
      {:ok, user}
    end

  end

  defp get_value(%{"Item" => %{"value" => %{"S" => value}}}), do: {:ok, value}
  defp get_value(map) when map == %{}, do: {:ok, nil}
end