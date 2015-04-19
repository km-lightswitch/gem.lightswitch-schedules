require_relative 'time_utility'

module Lightswitch

  class DailyUptimeSchedule

    attr_reader :start_hour, :start_minutes, :end_hour, :end_minutes

    def to_s
      "Daily uptime schedule: #{start_hour.to_s.rjust(2, '0')}:#{start_minutes.to_s.rjust(2, '0')} to #{end_hour.to_s.rjust(2, '0')}:#{end_minutes.to_s.rjust(2, '0')}"
    end

    def initialize(start_hour, start_minutes, end_hour, end_minutes)
      raise ArgumentError, "Ending time cannot precede start time" unless start_hour <= end_hour
      if (start_hour == end_hour)
        raise ArgumentError, "Ending time must follow start time" unless start_minutes < end_minutes
      end

      @start_hour, @start_minutes, @end_hour, @end_minutes = start_hour, start_minutes, end_hour, end_minutes
    end

    def up?(at_time)
      time_hour, time_minutes = at_time.hour, at_time.min

      if (start_hour..end_hour).include? time_hour
        return (start_minutes <= time_minutes) if (start_hour == time_hour)
        return (time_minutes <= end_minutes) if (end_hour == time_hour)
        true
      else
        false
      end
    end

    def down?(at_time)
      !up?(at_time)
    end

  end

  class Schedules
    include TimeUtility

    def create_daily_uptime_schedule(schedule_description)
      start_hour, start_minutes = get_hours_and_minutes(schedule_description[:start])
      end_hour, end_minutes = get_hours_and_minutes(schedule_description[:end])

      DailyUptimeSchedule.new(start_hour, start_minutes, end_hour, end_minutes)
    end

  end
end
