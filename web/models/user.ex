defmodule Api.User do
  use Api.Web, :model
  alias Api.Repo

  schema "users" do
    field :email, :string
    field :name, :string
    field :phone, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :is_admin, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :phone, :password, :is_admin])
    |> validate_required([:email, :name, :password])
    |> validate_changeset
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :name, :phone, :password])
    |> validate_required([:email, :name, :phone, :password])
    |> validate_changeset
  end

  defp validate_changeset(struct) do
    struct
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8)
    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/, [message: "Must include at least one lowercase letter, one uppercase letter, and one digit"])
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
