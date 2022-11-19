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
    Repo.all(Schema.Task)
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
  def get_task!(id), do: Repo.get!(Schema.Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Schema.Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Schema.Task{}
    |> Schema.Task.changeset(attrs)
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
    |> Schema.Task.changeset(attrs)
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
