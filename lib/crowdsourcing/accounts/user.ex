defmodule Crowdsourcing.Accounts.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :birth_date, :date
    field :citizenship, :string
    field :gender, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:gender, :birth_date, :citizenship, :name])
    |> validate_required([:gender, :birth_date, :citizenship, :name])
  end
end
