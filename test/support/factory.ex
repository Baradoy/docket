defmodule Docket.Factory do
  @moduledoc """
  Test Data Factory
  """
  use ExMachina.Ecto, repo: Docket.Repo

  alias Docket.Schema

  def task_factory do
    %Schema.Task{
      display_colour: Faker.Color.rgb_hex(),
      display_icon: random_enum(Schema.Task, :display_icon),
      frequency: Faker.random_between(0, 100),
      frequency_type: random_enum(Schema.Task, :frequency_type),
      subtitle: Faker.Company.catch_phrase(),
      title: Faker.Company.buzzword(),
      type: Faker.Company.bullshit(),
      appointments: [build(:task_appointment)]
    }
  end

  def task_appointment_factory do
    %Schema.TaskAppointment{
      completed_at: nil,
      scheduled_for: now(),
      status: :pending
    }
  end

  defp random_enum(schema, field),
    do: schema |> Ecto.Enum.values(field) |> Enum.random()

  defp now, do: DateTime.now!("Etc/UTC")
end
