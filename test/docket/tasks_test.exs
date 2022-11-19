defmodule Docket.TasksTest do
  use Docket.DataCase

  import Docket.Factory

  alias Docket.Tasks
  alias Docket.Schema

  describe "tasks" do
    @invalid_attrs %{
      display_colour: nil,
      display_icon: nil,
      frequency: nil,
      frequency_type: nil,
      subtitle: nil,
      title: nil,
      type: nil
    }

    test "list_tasks/0 returns all tasks" do
      task = insert(:task)
      assert Tasks.list_tasks() |> Enum.map(& &1.id) == [task.id]
    end

    test "get_task!/1 returns the task with given id" do
      task = insert(:task)
      assert Tasks.get_task!(task.id).id == task.id
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{
        display_colour: "some display_colour",
        display_icon: :bolt,
        frequency: 42,
        frequency_type: :hours,
        subtitle: "some subtitle",
        title: "some title",
        type: "some type"
      }

      assert {:ok, %Schema.Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.display_colour == "some display_colour"
      assert task.display_icon == :bolt
      assert task.frequency == 42
      assert task.frequency_type == :hours
      assert task.subtitle == "some subtitle"
      assert task.title == "some title"
      assert task.type == "some type"
      assert [%Schema.TaskAppointment{status: :pending}] = task.appointments
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = insert(:task)

      update_attrs = %{
        display_colour: "some updated display_colour",
        display_icon: :cog_6_tooth,
        frequency: 43,
        frequency_type: :days,
        subtitle: "some updated subtitle",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Schema.Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.display_colour == "some updated display_colour"
      assert task.display_icon == :cog_6_tooth
      assert task.frequency == 43
      assert task.frequency_type == :days
      assert task.subtitle == "some updated subtitle"
      assert task.title == "some updated title"
      assert task.type == "some updated type"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = insert(:task)
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task.display_colour == Tasks.get_task!(task.id).display_colour
    end

    test "delete_task/1 deletes the task" do
      task = insert(:task)
      assert {:ok, %Schema.Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = insert(:task)
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end

    test "complete_task/1 completes a task" do
      task = insert(:task)

      assert {:ok, task} = Tasks.complete_task(task)

      assert [%_{status: :pending}, %_{status: :complete}] = task.appointments
    end

    test "snooze_task/1 snoozes a task" do
      task = insert(:task)

      assert {:ok, task} = Tasks.snooze_task(task)

      assert [%_{status: :pending}, %_{status: :snoozed}] = task.appointments
    end
  end
end
