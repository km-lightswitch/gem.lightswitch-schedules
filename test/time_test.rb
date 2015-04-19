require_relative 'test_helper'

context "Lightswitch::Schedules" do

  context "create an uninterrupted daily schedule for uptime" do
    setup { Lightswitch::Schedules.new }

    asserts("create a 9 AM to 7 PM daily schedule for uptime using the specified timezone") {
      topic.create_schedule(nature: :daily, start: "0900", end: "1900", tz: "GMT", for: :uptime).occurring_at? Time.new(2015, 4, 19, 10, 0, 0, "+05:30")
    }

  end

end