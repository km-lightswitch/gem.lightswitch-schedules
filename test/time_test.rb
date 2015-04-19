require_relative 'test_helper'

context "Lightswitch::Schedules" do

  context "#create_daily_uptime_schedule" do
    setup { Lightswitch::Schedules.new }

    asserts("create a 9 AM to 7 PM daily schedule on the hours") {
      topic.create_daily_uptime_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 9, 0, 0)
      topic.create_daily_uptime_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 10, 0, 0)
      topic.create_daily_uptime_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 19, 0, 0)
    }

    denies("create a 9 AM to 7 PM daily schedule on the hours") {
      topic.create_daily_uptime_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 8, 59, 0)
      topic.create_daily_uptime_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 19, 1, 0)
    }

    asserts("create a 9 AM to 7 PM daily schedule on hours and minutes") {
      topic.create_daily_uptime_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 9, 23, 0)
      topic.create_daily_uptime_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 10, 0, 0)
      topic.create_daily_uptime_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 19, 40, 0)
    }

  end

end