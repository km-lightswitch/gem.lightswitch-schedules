require_relative 'schedule_creation'
require_relative 'persistence'

module Lightswitch

  class Schedules
    include ScheduleCreation

    def make_schedule(schedule_description)
      schedule_hash = to_schedule(schedule_description)
      Lightswitch::Schedule.new(schedule_hash)
    end

    def create_schedule_collection(schedules_description)
      schedule_collection = Lightswitch::ScheduleCollection.new({name: schedules_description[:name]})

      schedules = schedules_description[:schedules]
      uptime_schedules = schedules.collect { |schedule_description|
        make_schedule(schedule_description)
      }

      uptime_schedules.each { |schedule|
        schedule_collection.schedules << schedule
      }

      schedule_collection.save
      schedule_collection.id
    end

    def get_schedule_collection(id)
      Lightswitch::ScheduleCollection.get(id)
    end

  end
end
