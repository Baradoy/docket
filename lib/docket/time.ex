defmodule Docket.Time do
  @moduledoc """
  All of the time functions
  """

  @timezone Application.compile_env(:docket, :timezone)

  def now, do: Timex.now(@timezone)

  def same_day?(a, b) do
    a = a |> to_timezone |> Timex.to_date()
    b = b |> to_timezone |> Timex.to_date()

    Timex.compare(a, b) == 0
  end

  def to_timezone(datetime), do: Timex.Timezone.convert(datetime, @timezone)

  def duration_from_date(:hours, frequency, _date),
    do: Timex.Duration.from_hours(frequency)

  def duration_from_date(:days, frequency, _date),
    do: Timex.Duration.from_days(frequency)

  def duration_from_date(:weeks, frequency, _date),
    do: Timex.Duration.from_weeks(frequency)

  def duration_from_date(:months, frequency, date) do
    date |> Timex.shift(months: frequency) |> Timex.diff(date, :duration)
  end

  def duration_from_date(:day_of_month, frequency, date) do
    date
    |> Timex.shift(months: 1)
    |> Timex.beginning_of_month()
    |> Timex.shift(days: frequency)
    |> Timex.diff(date, :duration)
  end

  def add(datetime, duration) do
    Timex.add(datetime, duration)
  end

  def scale(duration, scale) do
    Timex.Duration.scale(duration, scale)
  end

  def relative_format(datetime, now) do
    if same_day?(datetime, now) do
      "today at " <> Timex.format!(datetime, "{h12}:{m} {am}")
    else
      datetime = add(datetime, Timex.Duration.from_minutes(15))
      Timex.Format.DateTime.Formatters.Relative.format!(datetime, "{relative}")
    end
  end
end
