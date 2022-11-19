defmodule Docket.Schema.TaskAppointment do
  @moduledoc """
  Tracks the individual times that a Task is scheduled.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Docket.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "task_appointments" do
    field :completed_at, :utc_datetime
    field :scheduled_for, :utc_datetime
    field :status, Ecto.Enum, values: [:pending, :complete, :snoozed]
    belongs_to :task, Schema.Task

    timestamps()
  end

  @doc false
  def changeset(task_appointment, attrs) do
    task_appointment
    |> cast(attrs, [:scheduled_for, :completed_at, :status])
    |> validate_required([:scheduled_for, :status])
  end
end
