defmodule Docket.Tasks do
  @moduledoc """
  The Schema.Tasks context.
  """

  import Ecto.Query, warn: false
  alias Docket.Repo

  alias Docket.Schema
  alias Docket.Time

  @snooze_scale 0.10

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Schema.Task{}, ...]

  """
  def list_tasks do
    Repo.all(task_queryable())
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Schema.Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Schema.Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(task_queryable(), id)

  def task_queryable do
    preload(Schema.Task, [:appointments])
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Schema.Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    first_appointment =
      change_task_appointment(
        %Schema.TaskAppointment{},
        %{scheduled_for: Time.now()}
      )

    %Schema.Task{}
    |> change_task(attrs)
    |> Ecto.Changeset.put_assoc(:appointments, [first_appointment])
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Schema.Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Schema.Task{} = task, attrs) do
    task
    |> change_task(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Schema.Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Schema.Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Schema.Task{}}

  """
  def change_task(%Schema.Task{} = task, attrs \\ %{}) do
    Schema.Task.changeset(task, attrs)
  end

  def complete_task(%Schema.Task{} = task) when is_list(task.appointments) do
    now = Time.now()
    appointments = put_status_for_pending_appointment(task, :complete, now)
    next_duration = Time.duration_from_date(task.frequency_type, task.frequency, now)
    scheduled_for = Time.add(now, next_duration)

    update_task(task, %{appointments: [%{scheduled_for: scheduled_for} | appointments]})
  end

  def snooze_task(%Schema.Task{} = task) when is_list(task.appointments) do
    now = Time.now()
    appointments = put_status_for_pending_appointment(task, :snoozed, now)

    next_duration = Time.duration_from_date(task.frequency_type, task.frequency, now)
    snooze_duration = Time.scale(next_duration, @snooze_scale)
    scheduled_for = Time.add(now, snooze_duration)

    update_task(task, %{appointments: [%{scheduled_for: scheduled_for} | appointments]})
  end

  defp put_status_for_pending_appointment(%Schema.Task{} = task, status, now)
       when is_list(task.appointments) do
    Enum.map(task.appointments, fn
      %_{status: :pending, id: id} -> %{completed_at: now, id: id, status: status}
      %_{status: _, id: id} -> %{id: id}
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task_appointment changes.

  ## Examples

      iex> change_task_appointment(task_appointment)
      %Ecto.Changeset{data: %Schema.TaskAppointment{}}

  """
  def change_task_appointment(%Schema.TaskAppointment{} = task_appointment, attrs \\ %{}) do
    Schema.TaskAppointment.changeset(task_appointment, attrs)
  end

  def current_appointment(%Schema.Task{} = task) when is_list(task.appointments) do
    task.appointments
    |> Enum.filter(fn appointment -> appointment.status == :pending end)
    |> List.first()
  end
end
