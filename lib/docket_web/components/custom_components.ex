defmodule DocketWeb.CustomComponents do
  @moduledoc """
  Custom Components
  """

  use Phoenix.Component

  attr :icon, :string, required: true

  attr :rest, :global,
    doc: "the arbitrary HTML attributes for the svg container",
    include: ~w(fill stroke stroke-width)

  attr :outline, :boolean, default: true
  attr :solid, :boolean, default: false
  attr :mini, :boolean, default: false
  attr :colour, :string

  def hero(assigns) do
    ~H"""
    <%= apply(Heroicons, @icon, [assigns]) %>
    """
  end

  attr :date, DateTime

  def relative_humanized_date(assigns) do
    ~H"""
    <span>
      <%= Timex.Format.DateTime.Formatters.Relative.format!(@date, "{relative}") %>
    </span>
    """
  end
end
