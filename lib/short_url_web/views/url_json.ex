defmodule ShortUrlWeb.UrlJSON do
  @doc """
  Renders a list of urls.
  """
  def index(%{urls: urls}) do
    %{data: for(url <- urls, do: data(url))}
  end

  @doc """
  Renders a single url.
  """
  def show(%{url: url}) do
    %{data: data(url)}
  end

  defp data(%{id: id, code_url: code_url, short_url: short_url, url: url}) do
    %{
      id: id,
      code_url: code_url,
      short_url: short_url,
      url: url
    }
  end
end
