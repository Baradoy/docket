defmodule Docket.TasksTest do
  use Docket.DataCase

  alias Docket.Tasks
  alias Docket.Schema

  describe "tasks" do
    import Docket.TasksFixtures

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
      task = task_fixture()
      assert Tasks.list_tasks() |> Enum.map(& &1.id) == [task.id]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
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
      task = task_fixture()

      update_attrs = %{
        display_colour: "some updated display_colour",
        display_icon: :"cog-6-tooth",
        frequency: 43,
        frequency_type: :days,
        subtitle: "some updated subtitle",
        title: "some updated title",
        type: "some updated type"
      }

      assert {:ok, %Schema.Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.display_colour == "some updated display_colour"
      assert task.display_icon == :"cog-6-tooth"
      assert task.frequency == 43
      assert task.frequency_type == :days
      assert task.subtitle == "some updated subtitle"
      assert task.title == "some updated title"
      assert task.type == "some updated type"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task.display_colour == Tasks.get_task!(task.id).display_colour
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Schema.Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end

  describe "task_appointments" do
    import Docket.TasksFixtures

    @invalid_attrs %{completed_at: nil, scheduled_for: nil, status: nil}

    test "list_task_appointments/0 returns all task_appointments" do
      task_appointment = task_appointment_fixture()
      assert Tasks.list_task_appointments() == [task_appointment]
    end

    test "get_task_appointment!/1 returns the task_appointment with given id" do
      task_appointment = task_appointment_fixture()
      assert Tasks.get_task_appointment!(task_appointment.id) == task_appointment
    end

    test "create_task_appointment/1 with valid data creates a task_appointment" do
      valid_attrs = %{
        completed_at: ~U[2022-11-17 22:32:00Z],
        scheduled_for: ~U[2022-11-17 22:32:00Z],
        status: :pending
      }

      assert {:ok, %Schema.TaskAppointment{} = task_appointment} =
               Tasks.create_task_appointment(valid_attrs)

      assert task_appointment.completed_at == ~U[2022-11-17 22:32:00Z]
      assert task_appointment.scheduled_for == ~U[2022-11-17 22:32:00Z]
      assert task_appointment.status == :pending
    end

    test "create_task_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task_appointment(@invalid_attrs)
    end

    test "update_task_appointment/2 with valid data updates the task_appointment" do
      task_appointment = task_appointment_fixture()

      update_attrs = %{
        completed_at: ~U[2022-11-18 22:32:00Z],
        scheduled_for: ~U[2022-11-18 22:32:00Z],
        status: :complete
      }

      assert {:ok, %Schema.TaskAppointment{} = task_appointment} =
               Tasks.update_task_appointment(task_appointment, update_attrs)

      assert task_appointment.completed_at == ~U[2022-11-18 22:32:00Z]
      assert task_appointment.scheduled_for == ~U[2022-11-18 22:32:00Z]
      assert task_appointment.status == :complete
    end

    test "update_task_appointment/2 with invalid data returns error changeset" do
      task_appointment = task_appointment_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Tasks.update_task_appointment(task_appointment, @invalid_attrs)

      assert task_appointment == Tasks.get_task_appointment!(task_appointment.id)
    end

    test "delete_task_appointment/1 deletes the task_appointment" do
      task_appointment = task_appointment_fixture()
      assert {:ok, %Schema.TaskAppointment{}} = Tasks.delete_task_appointment(task_appointment)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task_appointment!(task_appointment.id) end
    end

    test "change_task_appointment/1 returns a task_appointment changeset" do
      task_appointment = task_appointment_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task_appointment(task_appointment)
    end
  end
end
