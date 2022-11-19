defmodule Docket.Repo.Migrations.CreateTaskAppointments do
  use Ecto.Migration

  def change do
    create table(:task_appointments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :scheduled_for, :utc_datetime
      add :completed_at, :utc_datetime
      add :status, :string
      add :task_id, references(:tasks, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:task_appointments, [:task_id])
  end
end
