defmodule ShortUrl.Services.UrlParser do
  @moduledoc """
  Module responsible for converting url
  """
  @spec encode_url(integer()) :: binary()
  def encode_url(id) do
    id
    |> Integer.to_string()
    |> Base.encode64()
  end

  @spec decode_url(binary()) :: integer()
  def decode_url(encod) do
    encod
    |> Base.decode64!()
    |> String.to_integer()
  end

  def generate_short_url(code_url), do: ShortUrlWeb.Endpoint.url() <> "/" <> code_url
end
