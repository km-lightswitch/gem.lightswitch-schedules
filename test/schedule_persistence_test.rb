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
    schedule_collection = Lightswitch::ScheduleCollection.new
    schedule_collection.save
    schedule_collection
  }

  asserts("save works") { topic.id }

end

context "ScheduleCollection has schedules" do
  setup {
    daily_schedule = Lightswitch::Schedule.new(start_hour: 12, start_minutes: 23, end_hour: 18, end_minutes: 30)
    schedule_collection = Lightswitch::ScheduleCollection.new
    schedule_collection.schedules << daily_schedule
    schedule_collection.save
    schedule_collection
  }

  asserts("save schedule collection with schedule works") { Lightswitch::ScheduleCollection.get(topic.id).schedules.first.end_hour == 18 }

end