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

context "ScheduleCollection has single daily uptime schedule" do
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

context "ScheduleCollection has multiple daily uptime schedules" do
  setup {
    daily_schedule_longer = Lightswitch::Schedule.new(start_hour: 12, start_minutes: 23, end_hour: 18, end_minutes: 30)
    daily_schedule_shorter = Lightswitch::Schedule.new(start_hour: 14, start_minutes: 11, end_hour: 17, end_minutes: 41)
    schedule_collection = Lightswitch::ScheduleCollection.new(name: 'test')
    schedule_collection.schedules << daily_schedule_longer
    schedule_collection.schedules << daily_schedule_shorter
    schedule_collection.save
    schedule_collection
  }

  asserts("saved schedule collection responds to up?") { Lightswitch::ScheduleCollection.get(topic.id).up?(Time.new(2015, 4, 20, 14, 12, 0))}
  asserts("saved schedule collection responds to up?") { Lightswitch::ScheduleCollection.get(topic.id).up?(Time.new(2015, 4, 20, 17, 40, 0))}

  denies("saved schedule collection responds to up?") { Lightswitch::ScheduleCollection.get(topic.id).up?(Time.new(2015, 4, 20, 14, 7, 0))}
  denies("saved schedule collection responds to up?") { Lightswitch::ScheduleCollection.get(topic.id).up?(Time.new(2015, 4, 20, 17, 43, 0))}

end