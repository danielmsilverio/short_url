defmodule ShortUrl.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Changeset
  alias Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    has_many :urls, ShortUrl.Shorten.Url

    timestamps(type: :utc_datetime)
  end

  @required_fields ~w(name email)a
  @optional_fields ~w(password)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> put_password()
  end

  def put_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password, Bcrypt.hash_pwd_salt(password))
  end

  def put_password(changeset), do: changeset
end
