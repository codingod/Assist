defmodule Slackproject.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:payload) do
      add :message,        :string
      add :tag,        :string


      timestamps()
    end
  end
  
end
