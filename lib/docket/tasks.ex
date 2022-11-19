defmodule Docket.Tasks do
  @moduledoc """
  The Schema.Tasks context.
  """

  import Ecto.Query, warn: false
  alias Docket.Repo

  alias Docket.Schema

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
        %{scheduled_for: DateTime.now!("Etc/UTC")}
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
    now = Timex.now()
    appointments = put_status_for_pending_appointment(task, :complete, now)
    next_appointment = next_appoointment_attrs(task, now)

    update_task(task, %{appointments: [next_appointment | appointments]})
  end

  def snooze_task(%Schema.Task{} = task) when is_list(task.appointments) do
    now = Timex.now()
    appointments = put_status_for_pending_appointment(task, :snoozed, now)
    next_appointment = next_appoointment_attrs(task, now)

    update_task(task, %{appointments: [next_appointment | appointments]})
  end

  defp put_status_for_pending_appointment(%Schema.Task{} = task, status, now)
       when is_list(task.appointments) do
    Enum.map(task.appointments, fn
      %_{status: :pending, id: id} -> %{completed_at: now, id: id, status: status}
      %_{status: _, id: id} -> %{id: id}
    end)
  end

  def next_appoointment_attrs(%Schema.Task{} = task, now) do
    %{scheduled_for: next_appointment_date(task.frequency_type, task.frequency, now)}
  end

  def next_appointment_date(:hours, frequency, now),
    do: Timex.shift(now, hours: frequency)

  def next_appointment_date(:days, frequency, now),
    do: Timex.shift(now, days: frequency)

  def next_appointment_date(:months, frequency, now),
    do: Timex.shift(now, months: frequency)

  def next_appointment_date(:day_of_month, frequency, now),
    do:
      now
      |> Timex.shift(months: 1)
      |> Timex.beginning_of_month()
      |> Timex.shift(days: frequency)

  @doc """
  Returns the list of task_appointments.

  ## Examples

      iex> list_task_appointments()
      [%Schema.TaskAppointment{}, ...]

  """
  def list_task_appointments do
    Repo.all(Schema.TaskAppointment)
  end

  @doc """
  Gets a single task_appointment.

  Raises `Ecto.NoResultsError` if the Task appointment does not exist.

  ## Examples

      iex> get_task_appointment!(123)
      %Schema.TaskAppointment{}

      iex> get_task_appointment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task_appointment!(id), do: Repo.get!(Schema.TaskAppointment, id)

  @doc """
  Creates a task_appointment.

  ## Examples

      iex> create_task_appointment(%{field: value})
      {:ok, %Schema.TaskAppointment{}}

      iex> create_task_appointment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task_appointment(attrs \\ %{}) do
    %Schema.TaskAppointment{}
    |> Schema.TaskAppointment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task_appointment.

  ## Examples

      iex> update_task_appointment(task_appointment, %{field: new_value})
      {:ok, %Schema.TaskAppointment{}}

      iex> update_task_appointment(task_appointment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task_appointment(%Schema.TaskAppointment{} = task_appointment, attrs) do
    task_appointment
    |> Schema.TaskAppointment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task_appointment.

  ## Examples

      iex> delete_task_appointment(task_appointment)
      {:ok, %Schema.TaskAppointment{}}

      iex> delete_task_appointment(task_appointment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task_appointment(%Schema.TaskAppointment{} = task_appointment) do
    Repo.delete(task_appointment)
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
end
