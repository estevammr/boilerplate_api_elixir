defmodule Api.Core.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Api.Core.Task


  schema "tasks" do
    field :description, :string
    field :starts_on, :date
    field :ends_on, :date

    belongs_to :user, Api.Accounts.User

    timestamps()
  end

  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:description, :starts_on, :ends_on])
    |> validate_required([:description, :starts_on, :ends_on])
    |> validate_start_and_end_date
  end

  defp validate_start_and_end_date(changeset) do
    starts_on = get_field(changeset, :starts_on)
    ends_on = get_field(changeset, :ends_on)

    cond do
      ends_on < starts_on ->
        add_error(changeset, :ends_on, "Ends on should be greater than Starts on")
      ends_on >= starts_on ->
        changeset
    end
  end
end