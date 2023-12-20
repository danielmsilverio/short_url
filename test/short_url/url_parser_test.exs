defmodule ShortUrl.UrlParserTest do
  use ShortUrl.DataCase

  alias ShortUrl.Services.UrlParser

  @code_url Base.encode64("1")
  @short_url ShortUrlWeb.Endpoint.url() <> "/" <> @code_url

  describe "encode_url/1" do
    test "encode url" do
      assert @code_url == UrlParser.encode_url(1)
    end
  end

  describe "decode_url/1" do
    test "decode url" do
      assert 1 == UrlParser.decode_url(@code_url)
    end
  end

  describe "generate_short_url/1" do
    test "generate complete short url" do
      assert @short_url == UrlParser.generate_short_url(@code_url)
    end
  end
end
