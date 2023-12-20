defmodule ShortUrl.Services.AccountsTest do
  alias ShortUrl.Factory
  use ShortUrl.DataCase

  alias ShortUrl.Services.Accounts

  describe "users" do
    alias ShortUrl.Entities.User

    @invalid_attrs %{name: nil, email: nil, password: nil}

    test "get_user!/1 returns the user with given id" do
      user = Factory.insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{name: "some name", email: "some email", password: "some password"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.name == "some name"
      assert user.email == "some email"
      assert Bcrypt.verify_pass("some password", user.password)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = Factory.insert(:user)

      update_attrs = %{
        name: "some updated name",
        email: "some updated email",
        password: "some updated password"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.name == "some updated name"
      assert user.email == "some updated email"
      assert Bcrypt.verify_pass("some updated password", user.password)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = Factory.insert(:user)
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = Factory.insert(:user)
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = Factory.insert(:user)
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
