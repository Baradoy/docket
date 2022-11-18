defmodule Docket.Schema.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field :display_colour, :string
    field :display_icon, Ecto.Enum, values: [:bolt, :"cog-6-tooth", :cube, :"currency-dollar"]
    field :frequency, :integer
    field :frequency_type, Ecto.Enum, values: [:hours, :days, :months, :day_of_month]
    field :subtitle, :string
    field :title, :string
    field :type, :string

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
  end
end
