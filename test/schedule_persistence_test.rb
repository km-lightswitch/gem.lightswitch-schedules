require_relative 'test_helper'

context "Lightswitch::Schedule" do
  setup {
    daily_schedule = Lightswitch::Schedule.new(start_hour: 12, start_minutes: 30, end_hour: 17, end_minutes: 0)
    daily_schedule.save
    daily_schedule
  }

  asserts("save works") { Lightswitch::Schedule.get(topic.id).start_hour == 12 }

end

context "Lightswitch::ScheduleCollection" do

  setup {
    schedule_collection = Lightswitch::ScheduleCollection.new(name: 'test')
    schedule_collection.save
    schedule_collection
  }

  asserts("save works") { Lightswitch::ScheduleCollection.get(topic.id).name == 'test' }

end

context "ScheduleCollection has schedules" do
  setup {
    daily_schedule = Lightswitch::Schedule.new(start_hour: 12, start_minutes: 23, end_hour: 18, end_minutes: 30)
    schedule_collection = Lightswitch::ScheduleCollection.new(name: 'test')
    schedule_collection.schedules << daily_schedule
    schedule_collection.save
    schedule_collection
  }

  asserts("save schedule collection with schedule works") { Lightswitch::ScheduleCollection.get(topic.id).schedules.first.end_hour == 18 }
  asserts("saved schedule collection with schedule responds to up?") { Lightswitch::ScheduleCollection.get(topic.id).schedules.first.up?(Time.new(2015, 4, 20, 13, 1, 0))}

end