defmodule Docket.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :subtitle, :string
      add :type, :string
      add :display_colour, :string
      add :display_icon, :string
      add :frequency, :integer
      add :frequency_type, :string

      timestamps()
    end
  end
end
