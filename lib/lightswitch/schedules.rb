require 'ice_cube'

module Lightswitch
  class Schedules

    def create_schedule(schedule_description)
      IceCube::Schedule.new(Time.now)
    end

  end
end
