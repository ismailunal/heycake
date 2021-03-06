defmodule HeyCake.Teams.Team do
  @moduledoc """
  User schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias HeyCake.Callouts.Callout
  alias HeyCake.Users.User

  @type t :: %__MODULE__{}

  schema "teams" do
    field(:slack_id, :string)
    field(:token, :string)

    belongs_to(:user, User)

    has_many(:callouts, Callout)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:slack_id, :token, :user_id])
    |> validate_required([:slack_id, :token, :user_id])
    |> unique_constraint(:slack_id)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:slack_id, :token, :user_id])
    |> validate_required([:slack_id, :token, :user_id])
    |> unique_constraint(:slack_id)
  end
end
