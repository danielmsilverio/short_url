defmodule ShortUrl.Entities.Url do
  use Ecto.Schema
  import Ecto.Changeset

  schema "urls" do
    field :url, :string
    belongs_to :user, ShortUrl.Entities.User

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(url user_id)a
  @optional_fields ~w()a

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
