defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Accounts.User


  schema "users" do
    field :email,                 :string
    field :full_name,             :string
    field :password,              :string, virtual: true
    field :password_hash,         :string
    field :authentication_token,  :string

    has_many :tasks, Api.Core.Task, on_delete: :delete_all

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:full_name, :email, :password])
    |> validate_required([:full_name, :email, :password])
    |> validate_length(:email, min: 6, max: 255)
    |> validate_format(:email, ~r/\A[^@\s]+@[^@\s]+\z/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 6, max: 30)
    |> encrypt_password
    |> put_authentication_token
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
        _ ->
          changeset
    end
  end

  defp put_authentication_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :authentication_token, SecureRandom.urlsafe_base64(32))
      _ ->
        changeset
    end
  end
end