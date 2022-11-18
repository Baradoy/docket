defmodule Docket.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Docket.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        display_colour: "some display_colour",
        display_icon: :bolt,
        frequency: 42,
        frequency_type: :hours,
        subtitle: "some subtitle",
        title: "some title",
        type: "some type"
      })
      |> Docket.Tasks.create_task()

    task
  end
end
