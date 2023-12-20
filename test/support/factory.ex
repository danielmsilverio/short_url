defmodule ShortUrl.Factory do
  use ExMachina.Ecto, repo: ShortUrl.Repo

  def user_factory do
    %ShortUrl.Accounts.User{
      name: "Daniel Test",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: Bcrypt.hash_pwd_salt("teste")
    }
  end

  def url_factory do
    user = build(:user)

    %ShortUrl.Shorten.Url{
      url: "teste.com",
      user: user
    }
  end
end
