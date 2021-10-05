defmodule Fua.EntryPoint.User.UserControllerTest do
  alias Fua.EntryPoint.User.UserController

  use ExUnit.Case
  use Plug.Test
  doctest Fua.Application

  @opts UserController.init([])

  test "returns hello" do
    conn =
      :get
      |> conn("/hello", "")
      |> UserController.call(@opts)

    assert conn.state == :sent
    assert conn.resp_body == "\"Hello\""
    assert conn.status == 200
  end

  test "returns 404" do
    conn =
      :get
      |> conn("/missing", "")
      |> UserController.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end