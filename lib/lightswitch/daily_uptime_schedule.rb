require_relative 'constants'
require_relative 'time_utility'
require_relative 'schedule_mixin'

module Lightswitch

  class DailyUptimeSchedule
    include TimeUtility, ScheduleMixin

    attr_reader :start_hour, :start_minutes, :end_hour, :end_minutes

    def initialize(start_time_of_day, end_time_of_day = nil)
      start_hour, start_minutes = get_hours_and_minutes(start_time_of_day)

      if end_time_of_day
        end_hour, end_minutes = get_hours_and_minutes(end_time_of_day)

        raise ArgumentError, "Ending time cannot precede start time" unless start_hour <= end_hour
        if (start_hour == end_hour)
          raise ArgumentError, "Ending time must follow start time" unless start_minutes < end_minutes
        end
      end

      end_hour, end_minutes = end_time_of_day ? [end_hour, end_minutes] : [Constants::END_OF_DAY_HOURS, Constants::END_OF_DAY_MINUTES]

      @start_hour, @start_minutes, @end_hour, @end_minutes = start_hour, start_minutes, end_hour, end_minutes
    end

  end
end