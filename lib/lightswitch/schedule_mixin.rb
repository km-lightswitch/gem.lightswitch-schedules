module Lightswitch
  module ScheduleMixin

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


    def to_s
      "Daily uptime schedule: #{start_time_of_day} to #{end_time_of_day}"
    end


    def start_time_of_day;
      "#{start_hour.to_s.rjust(2, '0')}:#{start_minutes.to_s.rjust(2, '0')}";
    end


    def end_time_of_day;
      (end_hour and end_minutes) ? "#{end_hour.to_s.rjust(2, '0')}:#{end_minutes.to_s.rjust(2, '0')}" : "end of day";
    end

  end
end