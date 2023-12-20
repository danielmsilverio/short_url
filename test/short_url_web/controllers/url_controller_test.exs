defmodule ShortUrlWeb.UrlControllerTest do
  use ShortUrlWeb.ConnCase
  alias ShortUrl.Factory

  @invalid_attrs %{short_url: nil, url: nil}

  setup %{conn: conn} do
    %{id: user_id} = Factory.insert(:user)

    create_attrs = %{
      short_url: "some short_url",
      url: "teste.com",
      user_id: user_id
    }

    {:ok, create_attrs: create_attrs, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create url" do
    test "renders url when data is valid", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/urls", url: create_attrs)

      assert %{
               "id" => id,
               "code_url" => code_url,
               "short_url" => short_url,
               "url" => "teste.com"
             } = json_response(conn, 201)["data"]

      id_converted =
        id
        |> Integer.to_string()
        |> Base.encode64()

      assert code_url == id_converted
      assert short_url == ShortUrlWeb.Endpoint.url() <> "/" <> id_converted

      conn = get(conn, ~p"/api/urls/#{id}")

      assert %{
               "id" => ^id,
               "short_url" => ^short_url,
               "url" => "teste.com",
               "code_url" => ^code_url
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/urls", url: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete url" do
    test "deletes chosen url", %{conn: conn} do
      url = Factory.insert(:url)
      conn = delete(conn, ~p"/api/urls/#{url}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/urls/#{url}")
      end
    end
  end

  describe "redirect page" do
    test "redirect to url", %{conn: conn, create_attrs: create_attrs} do
      conn = post(conn, ~p"/api/urls", url: create_attrs)
      assert response(conn, 201)

      %{"code_url" => code_url} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/#{code_url}")
      assert response(conn, 302)
    end
  end
end
