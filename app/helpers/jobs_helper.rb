module JobsHelper

  def intervals
    [
     ["Every 1 minute", "minutely"], ["Every 15 minutes", "15minutely"],
     ["Every hour", "hourly"], ["Every day", "daily"], 
     ["Every week", "weekly"], ["Every montth", "monthly"]
    ]
  end

  def minutes
    array_with_nil_and(0..59)
  end

  def hours
    array_with_nil_and(0..23)
  end

  def days_of_month
    array_with_nil_and(1..31)
  end

  def months
    array_with_nil_and(1..12)
  end

  def days_of_week
    array_with_nil_and(1..7)
  end

  def array_with_nil_and(range)
    [["Any", nil]] + range.to_a
  end

  def string_time_equivalent
    { "minutely" => 1.minute, "15minutely" => 15.minutes, "hourly" => 1.hour, 
      "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month }
  end

  def string_view_equivalent
    { "minutely" => "minute", "15minutely" => "15 minutes", "hourly" => "hour", 
      "daily" => "day", "weekly" => "week", "monthly" => "month" }
  end

end