defmodule Fua.EntryPoint.Client.ClientController do
  use Plug.Router
  use Plug.ErrorHandler

  require Logger

  alias Fua.Model.Error
  alias Fua.Model.User
  alias Fua.UseCase.UserDynamodbUseCase
  alias Fua.UseCase.UserRedisUseCase

  plug(CORSPlug,
    methods: ["GET", "POST"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:fua, :plug])
  plug(:dispatch)

  get "/hello" do
    "Hello"
    |> build_response(conn)
  end

  get "/user/get/redis" do
    id = conn.params["id"] || "0"

    with {:ok, response} <- UserRedisUseCase.get(id) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  get "/user/set/redis" do
    id = conn.params["id"] || UUID.uuid1

    with {:ok, response} <- UserRedisUseCase.set(%User{id: id, name: "Test"}) do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end


  get "/user/get/dynamodb" do
    with {:ok, response} <- UserDynamodbUseCase.get("123") do
      build_response(%{status: 200, body: response}, conn)
    else error -> handle_error(error, conn) end
  end

  match _ do
    %{request_path: path} = conn
    build_response(%{status: 404, body: %{status: 404, path: path}}, conn)
  end

  defp build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  defp build_response(response, conn),
     do: build_response(%{status: 200, body: response}, conn)


  defp handle_error({:error, %Error{} = e}, conn) do
    Logger.error("Error #{inspect(e)}}")
    build_response(%{status: 409, body: %{status: 409, error: e}}, conn)
  end

  defp _handle_error(error, conn) do
    Logger.error("Unexpected error #{inspect(error)}}")
    build_response(%{status: 500, body: %{status: 500, error: "Error"}}, conn)
  end


  @impl Plug.ErrorHandler
  defp handle_errors(conn, %{} = error) do
    Logger.error("Internal server - #{inspect(error)}}")

    build_response(%{status: 500, body: %{status: 500, error: "Internal server"}}, conn)
  end

end
