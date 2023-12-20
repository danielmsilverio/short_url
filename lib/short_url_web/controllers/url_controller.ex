defmodule ShortUrlWeb.UrlController do
  use ShortUrlWeb, :controller

  alias ShortUrl.Services.Shorten
  alias ShortUrl.Entities.Url

  action_fallback ShortUrlWeb.FallbackController

  def create(conn, %{"url" => url_params}) do
    with {:ok, %Url{} = url} <- Shorten.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/urls/#{url}")
      |> render(:show, url: url)
    end
  end

  def show(conn, %{"id" => id}) do
    url = Shorten.get_url!(id)
    render(conn, :show, url: url)
  end

  def delete(conn, %{"id" => id}) do
    url = Shorten.get_url!(id)

    with {:ok, %Url{}} <- Shorten.delete_url(url) do
      send_resp(conn, :no_content, "")
    end
  end

  def redirect_page(conn, %{"code" => code}) do
    with %{url: url} <- Shorten.get_url_by_code!(code) do
      conn
      |> resp(:found, "")
      |> put_resp_header("location", url)
    end
  end
end
