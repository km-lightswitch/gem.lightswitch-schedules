require_relative 'test_helper'

context "Lightswitch::Schedules" do

  context "#make_schedule given only start time" do
    setup { Lightswitch::Schedules.new }

    asserts("create a 9 AM start daily schedule") {
      topic.make_schedule(start: "0900").up? Time.new(2015, 4, 19, 9, 0, 0)
      topic.make_schedule(start: "2300").up? Time.new(2015, 4, 19, 23, 59, 0)
    }

    denies("create a 9 AM start daily schedule") {
      topic.make_schedule(start: "0900").up? Time.new(2015, 4, 19, 8, 59, 0)
      topic.make_schedule(start: "0900").up? Time.new(2015, 4, 19, 1, 0, 0)
    }

  end

  context "#make_schedule given both start and end times" do
    setup { Lightswitch::Schedules.new }

    asserts("raises an error for invalid arguments when end hour is earlier than start hour") { topic.make_schedule(start: "0900", end: "0859") }.raises(ArgumentError) { "Ending time cannot precede start time" }
    asserts("raises an error for invalid arguments when end is same as start") { topic.make_schedule(start: "0900", end: "0900") }.raises(ArgumentError) { "Ending time must follow start time" }
    asserts("raises an error for invalid arguments when end is same earlier than start on the same hour") { topic.make_schedule(start: "0923", end: "0922") }.raises(ArgumentError) { "Ending time must follow start time" }

    asserts("create a 9 AM to 7 PM daily schedule on the hours") {
      topic.make_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 9, 0, 0)
      topic.make_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 10, 0, 0)
      topic.make_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 19, 0, 0)
    }

    denies("create a 9 AM to 7 PM daily schedule on the hours") {
      topic.make_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 8, 59, 0)
      topic.make_schedule(start: "0900", end: "1900").up? Time.new(2015, 4, 19, 19, 1, 0)
    }

    asserts("create a 9 AM to 7 PM daily schedule on hours and minutes") {
      topic.make_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 9, 23, 0)
      topic.make_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 10, 0, 0)
      topic.make_schedule(start: "0923", end: "1941").up? Time.new(2015, 4, 19, 19, 40, 0)
    }

  end

  context "#create_schedules" do
    setup {
      schedule_description = {
          :name => 'test',
          :schedules => [{start: '1100', end: '1230'}]
      }
      Lightswitch::Schedules.new.create_schedule_collection(schedule_description)
    }

    asserts("constructs, persists, and retrieves a schedule collection by id given a description of schedules") { Lightswitch::Schedules.new.get_schedule_collection(topic).up? Time.new(2015, 4, 20, 11, 35, 0) }
  end

  context "#get_scheduled_state_change_at_time" do
    setup {
      schedule_description = {
          :name => 'test',
          :schedules => [{start: '1100', end: '1230'}]
      }
      Lightswitch::Schedules.new.create_schedule_collection(schedule_description)
    }
    asserts("indicates a state change of up") { Lightswitch::Schedules.new.get_scheduled_state_change_at_time("down", Time.new(2015, 4, 21, 11, 40, 0), topic).equal? Lightswitch::StateChange.new("up", Time.new(2015, 4, 21, 11, 40, 0)) }
    asserts("indicates no state change") { Lightswitch::Schedules.new.get_scheduled_state_change_at_time("down", Time.new(2015, 4, 21, 10, 40, 0), topic).nil? }
  end

  context "#get_scheduled_state_changes" do
    setup {
      schedule_description = {
          :name => 'test',
          :schedules => [{start: '1100', end: '1230'}]
      }
      id = Lightswitch::Schedules.new.create_schedule_collection(schedule_description)
      Lightswitch::Schedules.new.get_scheduled_state_changes('down', Time.new(2015, 4, 22, 12, 28, 0), Time.new(2015, 4, 22, 12, 33, 0), id)
    }

    asserts("produces multiple state changes near a state change boundary") { topic.first.equal?(Lightswitch::StateChange.new('up', Time.new(2015, 4, 22, 12, 28, 0))) and topic.last.equal?(Lightswitch::StateChange.new('down', Time.new(2015, 4, 22, 12, 33, 0))) }
    # asserts("gets no changes where none are applicable") {}
    # asserts("gets a single change when only one is applicable") {}

  end

end