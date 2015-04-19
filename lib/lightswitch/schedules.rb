require_relative 'time_utility'
require_relative 'constants'

module Lightswitch

  class DailyUptimeSchedule
    include TimeUtility

    attr_reader :start_hour, :start_minutes, :end_hour, :end_minutes

    def to_s
      "Daily uptime schedule: #{start_time_of_day} to #{end_time_of_day}"
    end

    def start_time_of_day;
      "#{start_hour.to_s.rjust(2, '0')}:#{start_minutes.to_s.rjust(2, '0')}";
    end

    def end_time_of_day;
      (end_hour and end_minutes) ? "#{end_hour.to_s.rjust(2, '0')}:#{end_minutes.to_s.rjust(2, '0')}" : "end of day";
    end


    def initialize(start_time_of_day, end_time_of_day = nil)
      start_hour, start_minutes = get_hours_and_minutes(start_time_of_day)

      if end_time_of_day
        end_hour, end_minutes = get_hours_and_minutes(end_time_of_day)

        raise ArgumentError, "Ending time cannot precede start time" unless start_hour <= end_hour
        if (start_hour == end_hour)
          raise ArgumentError, "Ending time must follow start time" unless start_minutes < end_minutes
        end
      end

      @start_hour, @start_minutes = start_hour, start_minutes
      @end_hour, @end_minutes = end_time_of_day ? [end_hour, end_minutes] : [Constants::END_OF_DAY_HOURS, Constants::END_OF_DAY_MINUTES]
    end

    def up?(at_time)
      time_hour, time_minutes = at_time.hour, at_time.min

      unless (end_hour and end_minutes)
        return after_start_time(time_hour, time_minutes)
      else

        if (start_hour..end_hour).include? time_hour
          return (start_minutes <= time_minutes) if (start_hour == time_hour)
          return (time_minutes <= end_minutes) if (end_hour == time_hour)
          true
        else
          false
        end

      end
    end

    def after_start_time(hour, minutes)
      (hour > start_hour) or ((hour == start_hour) and (minutes >= start_minutes))
    end

    def down?(at_time)
      !up?(at_time)
    end

  end

  class Schedules

    def create_daily_uptime_schedule(schedule_description)
      start_time_of_day = schedule_description[:start]
      end_time_of_day = schedule_description[:end] || nil

      DailyUptimeSchedule.new(start_time_of_day, end_time_of_day)
    end

  end
end
