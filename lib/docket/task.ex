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
end
