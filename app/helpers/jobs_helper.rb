module JobsHelper

  def intervals
    ["minutely", "15minutely", "hourly", "daily", "weekly", "monthly"]
  end

  def string_time_equivalent
    { "minutely" => 1.minute, "15minutely" => 15.minutes, "hourly" => 1.hour, 
      "daily" => 1.day, "weekly" => 1.week, "monthly" => 1.month }
  end

end