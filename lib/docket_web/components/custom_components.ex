defmodule DocketWeb.CustomComponents do
  @moduledoc """
  Custom Components
  """

  use Phoenix.Component

  alias Docket.Time

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

  attr :datetime, DateTime, required: true
  attr :now, DateTime, required: true

  def relative_humanized_date(assigns) do
    ~H"""
    <span>
      <%= Time.relative_format(@datetime, @now) %>
    </span>
    """
  end
end
