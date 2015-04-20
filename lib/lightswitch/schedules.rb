require_relative 'daily_uptime_schedule'

module Lightswitch

  class Schedules

    def create_daily_uptime_schedule(schedule_description)
      start_time_of_day = schedule_description[:start]
      end_time_of_day = schedule_description[:end] || nil

      DailyUptimeSchedule.new(start_time_of_day, end_time_of_day)
    end

  end
end
