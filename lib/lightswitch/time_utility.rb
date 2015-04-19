module Lightswitch
  module TimeUtility

    def get_hours_and_minutes(tod_string)
      raise ArgumentError, "Please specify a time of day as 'hhmm', was given '#{tod_string}' instead" unless (tod_string and tod_string.length == 4)

      hours = tod_string.slice(0, 2).to_i
      raise ArgumentError, "Please specify a time in hours ranging from 0 to 23, was given '#{hours}' in '#{tod_string}' instead" unless (0..23).include? hours

      minutes = tod_string.slice(2, 2).to_i
      raise ArgumentError, "Please specify a time in minutes ranging from 0 to 59, was given '#{minutes}' in '#{tod_string}' instead" unless (0..59).include? minutes

      [hours, minutes]
    end

  end
end