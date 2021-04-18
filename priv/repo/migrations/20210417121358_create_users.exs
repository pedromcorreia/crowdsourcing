defmodule Crowdsourcing.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :gender, :string
      add :birth_date, :date
      add :citizenship, :string
      add :name, :string

      timestamps()
    end
  end
end
