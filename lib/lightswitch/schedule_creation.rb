require_relative 'constants'

module Lightswitch
  module ScheduleCreation


    def get_hours_and_minutes(tod_string)
      raise ArgumentError, "Please specify a time of day as 'hhmm', was given '#{tod_string}' instead" unless (tod_string and tod_string.length == 4)

      hours = tod_string.slice(0, 2).to_i
      raise ArgumentError, "Please specify a time in hours ranging from 0 to 23, was given '#{hours}' in '#{tod_string}' instead" unless (0..23).include? hours

      minutes = tod_string.slice(2, 2).to_i
      raise ArgumentError, "Please specify a time in minutes ranging from 0 to 59, was given '#{minutes}' in '#{tod_string}' instead" unless (0..59).include? minutes

      [hours, minutes]
    end


    def from_h(schedule_description)
      start_time_of_day = schedule_description[:start]
      start_hour, start_minutes = get_hours_and_minutes(start_time_of_day)

      end_time_of_day = schedule_description[:end]

      if end_time_of_day
        end_hour, end_minutes = get_hours_and_minutes(end_time_of_day)

        raise ArgumentError, "Ending time cannot precede start time" unless start_hour <= end_hour
        if (start_hour == end_hour)
          raise ArgumentError, "Ending time must follow start time" unless start_minutes < end_minutes
        end
      end

      end_hour, end_minutes = end_time_of_day ? [end_hour, end_minutes] : [Constants::END_OF_DAY_HOURS, Constants::END_OF_DAY_MINUTES]

      {start_hour: start_hour, start_minutes: start_minutes, end_hour: end_hour, end_minutes: end_minutes}
    end


  end
end