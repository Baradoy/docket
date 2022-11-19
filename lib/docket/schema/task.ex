defmodule Docket.Schema.Task do
  @moduledoc """
  A Tasks is the top level repeatable element.

  Example:
    Water the flowers every week
    Take the Dog for a walk daily
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Docket.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :display_colour, :string
    field :display_icon, Ecto.Enum, values: [:bolt, :"cog-6-tooth", :cube, :"currency-dollar"]
    field :frequency, :integer
    field :frequency_type, Ecto.Enum, values: [:hours, :days, :weeks, :months, :day_of_month]
    field :subtitle, :string
    field :title, :string
    field :type, :string

    has_many :appointments, Schema.TaskAppointment

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [
      :title,
      :subtitle,
      :type,
      :display_colour,
      :display_icon,
      :frequency,
      :frequency_type
    ])
    |> validate_required([
      :title,
      :subtitle,
      :type,
      :display_colour,
      :display_icon,
      :frequency,
      :frequency_type
    ])
    |> cast_assoc(:appointments)
  end
end
