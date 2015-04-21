require_relative 'schedule_creation'
require_relative 'models'
require_relative 'constants'

module Lightswitch

  class Schedules
    include ScheduleCreation

    def make_schedule(schedule_description)
      Lightswitch::Schedule.new(from_h(schedule_description))
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


    def get_scheduled_state_changes(state, from_time, to_time, schedules_id)
      [from_time, to_time].collect { |time| get_scheduled_state_change_at_time(state, time, schedules_id) }
    end


    def get_scheduled_state_change_at_time(state, at_time, schedules_id)
      schedule_collection = Lightswitch::ScheduleCollection.get(schedules_id)
      schedule_collection.get_schedule_state_change(state, at_time)
    end

  end
end