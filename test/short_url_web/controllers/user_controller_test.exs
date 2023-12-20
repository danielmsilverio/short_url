defmodule ShortUrlWeb.UserControllerTest do
  use ShortUrlWeb.ConnCase

  alias ShortUrl.Services.Accounts
  alias ShortUrl.Factory

  @create_attrs %{
    name: "some name",
    email: "some email",
    password: "some password"
  }
  @update_attrs %{
    name: "some updated name",
    email: "some updated email",
    password: "some updated password"
  }
  @invalid_attrs %{name: nil, email: nil, password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "name" => "some name"
             } = json_response(conn, 200)["data"]

      %{password: password} = Accounts.get_user!(id)

      assert Bcrypt.verify_pass("some password", password)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    test "renders user when data is valid", %{conn: conn} do
      user = %{id: id} = Factory.insert(:user)
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]

      %{password: password} = Accounts.get_user!(id)

      assert Bcrypt.verify_pass("some updated password", password)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = Factory.insert(:user)
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn} do
      user = Factory.insert(:user)
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end
end
