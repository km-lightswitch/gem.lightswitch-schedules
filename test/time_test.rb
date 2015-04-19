require_relative 'test_helper'

context "Lightswitch::Schedules" do

  context "#create_daily_uptime_schedule given only start time" do
    setup { Lightswitch::Schedules.new }

    asserts("create a 9 AM start daily schedule") {
      topic.create_daily_uptime_schedule(start: "0900").up? Time.new(2015, 4, 19, 9, 0, 0)
      topic.create_daily_uptime_schedule(start: "2300").up? Time.new(2015, 4, 19, 23, 59, 0)
    }

    denies("create a 9 AM start daily schedule") {
      topic.create_daily_uptime_schedule(start: "0900").up? Time.new(2015, 4, 19, 8, 59, 0)
      topic.create_daily_uptime_schedule(start: "0900").up? Time.new(2015, 4, 19, 1, 0, 0)
    }

  end

  context "#create_daily_uptime_schedule given both start and end times" do
    setup { Lightswitch::Schedules.new }

    asserts("raises an error for invalid arguments when end hour is earlier than start hour") { topic.create_daily_uptime_schedule(start: "0900", end: "0859") }.raises(ArgumentError) { "Ending time cannot precede start time" }
    asserts("raises an error for invalid arguments when end is same as start") { topic.create_daily_uptime_schedule(start: "0900", end: "0900") }.raises(ArgumentError) { "Ending time must follow start time" }
    asserts("raises an error for invalid arguments when end is same earlier than start on the same hour") { topic.create_daily_uptime_schedule(start: "0923", end: "0922") }.raises(ArgumentError) { "Ending time must follow start time" }

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