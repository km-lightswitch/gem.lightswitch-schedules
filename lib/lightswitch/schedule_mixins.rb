module Lightswitch
  module ScheduleCommon

    def encode_state(up_boolean)
      up_boolean ? 'up' : 'down'
    end

    def decode_state(state_string)
      state_string == 'up'
    end

    def get_schedule_state_change(reference_state, at_time)
      scheduled_state_encoded = encode_state(up?(at_time))
      if (scheduled_state_encoded != reference_state)
        StateChange.new(scheduled_state_encoded, at_time)
      else
        nil
      end
    end

  end


  module ScheduleCollectionMixin
    include ScheduleCommon


    def up?(at_time)
      !(schedules.any? { |schedule| schedule.down?(at_time) })
    end


    def down?(at_time)
      !up?(at_time)
    end


  end


  class StateChange
    attr_accessor :state, :at_time

    def initialize(state_string, at_time)
      @state, @at_time = state_string, at_time
    end

    def to_h
      {state: state, at_time: at_time}
    end

    def to_s; to_h; end

    def equal?(other)
      other.is_a? StateChange and (other.state == state and other.at_time == at_time)
    end
  end


  module ScheduleMixin
    include ScheduleCommon

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


    def start_time_of_day
      "#{start_hour.to_s.rjust(2, '0')}:#{start_minutes.to_s.rjust(2, '0')}"
    end


    def end_time_of_day
      (end_hour and end_minutes) ? "#{end_hour.to_s.rjust(2, '0')}:#{end_minutes.to_s.rjust(2, '0')}" : "end of day"
    end

  end
end