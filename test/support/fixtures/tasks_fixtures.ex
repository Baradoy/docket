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

  @doc """
  Generate a task_appointment.
  """
  def task_appointment_fixture(attrs \\ %{}) do
    {:ok, task_appointment} =
      attrs
      |> Enum.into(%{
        completed_at: ~U[2022-11-17 22:32:00Z],
        scheduled_for: ~U[2022-11-17 22:32:00Z],
        status: :pending
      })
      |> Docket.Tasks.create_task_appointment()

    task_appointment
  end
end
