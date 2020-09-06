defmodule Z19rpw.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Z19rpw.Accounts.User

  schema "users" do
    field :hashed_password, :string
    field :permissions, :map
    field :username, :string

    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password, :permissions])
    |> validate_required([:username, :password, :permissions])
    |> unique_constraint(:username)
    |> put_hashed_password()
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :hashed_password, Bcrypt.hash_pwd_salt(password))
      _ ->
        changeset
    end
  end
end
