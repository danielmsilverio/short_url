defmodule ShortUrl.Shorten do
  @moduledoc """
  The Shorten context.
  """

  import Ecto.Query, warn: false
  alias ShortUrl.Repo

  alias ShortUrl.Shorten.Url

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(123)
      %Url{}

      iex> get_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Url |> Repo.get!(id) |> build_url()

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %Url{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    result =
      %Url{}
      |> Url.changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, url} ->
        {:ok, build_url(url)}

      error ->
        error
    end
  end

  @doc """
  Deletes a url.

  ## Examples

      iex> delete_url(url)
      {:ok, %Url{}}

      iex> delete_url(url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_url(%Url{} = url) do
    Repo.delete(url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking url changes.

  ## Examples

      iex> change_url(url)
      %Ecto.Changeset{data: %Url{}}

  """
  def change_url(%Url{} = url, attrs \\ %{}) do
    Url.changeset(url, attrs)
  end

  def get_url_by_code!(code) do
    id = decode_url(code)

    Url
    |> Repo.get!(id)
    |> build_url()
  end

  defp build_url(%Url{id: id} = url) do
    code_url = encode_url(id)
    short_url = generate_short_url(code_url)

    Map.merge(url, %{
      code_url: code_url,
      short_url: short_url
    })
  end

  defp encode_url(id) do
    id
    |> Integer.to_string()
    |> Base.encode64()
  end

  defp decode_url(encod) do
    encod
    |> Base.decode64!()
    |> String.to_integer()
  end

  defp generate_short_url(code_url), do: ShortUrlWeb.Endpoint.url() <> "/" <> code_url
end
