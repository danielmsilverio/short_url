defmodule ShortUrl.ShortenTest do
  alias ShortUrl.Factory
  use ShortUrl.DataCase

  alias ShortUrl.Shorten

  describe "urls" do
    alias ShortUrl.Entities.Url

    @invalid_attrs %{short_url: nil, url: nil}

    test "get_url!/1 returns the url with given id" do
      %{id: id, inserted_at: inserted_at, updated_at: updated_at, url: url, user_id: user_id} =
        Factory.insert(:url)

      assert %{
               id: ^id,
               inserted_at: ^inserted_at,
               updated_at: ^updated_at,
               url: ^url,
               user_id: ^user_id
             } = Shorten.get_url!(id)
    end

    test "create_url/1 with valid data creates a url" do
      %{id: user_id} = Factory.insert(:user)
      valid_attrs = %{url: "some url", user_id: user_id}

      assert {:ok, %Url{id: id} = url} = Shorten.create_url(valid_attrs)

      id_converted =
        id
        |> Integer.to_string()
        |> Base.encode64()

      assert url.url == "some url"
      assert url.code_url == id_converted
      assert url.short_url == ShortUrlWeb.Endpoint.url() <> "/" <> id_converted
    end

    test "create_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shorten.create_url(@invalid_attrs)
    end

    test "delete_url/1 deletes the url" do
      url = Factory.insert(:url)
      assert {:ok, %Url{}} = Shorten.delete_url(url)
      assert_raise Ecto.NoResultsError, fn -> Shorten.get_url!(url.id) end
    end

    test "change_url/1 returns a url changeset" do
      url = Factory.insert(:url)
      assert %Ecto.Changeset{} = Shorten.change_url(url)
    end
  end
end
