defmodule Api.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Api.{Repo, Accounts.User}

  def for_token(%User{} = user), do: {:ok, "User:#{user.authentication_token}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> authentication_token) do
     {:ok, Repo.get_by(User, authentication_token: authentication_token)}
  end
  def from_token(_), do: {:error, "Unknown resource type"}
end