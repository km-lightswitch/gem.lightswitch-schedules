require_relative 'test_helper'

class IncludesTimeUtility
  include Lightswitch::ScheduleCreation
end

context "Lightswitch::ScheduleCreation" do

  context "#get_hours_and_minutes" do
    setup { IncludesTimeUtility.new }
    asserts("parses a time of day accurately") { topic.get_hours_and_minutes('1703') == [17, 3] }
    asserts("parses a time of day accurately at midnight") { topic.get_hours_and_minutes('0000') == [0, 0] }
    asserts("parses a time of day accurately just before midnight") { topic.get_hours_and_minutes('2359') == [23, 59] }

    asserts("raises an exception for a time-of-day string that is too long") { topic.get_hours_and_minutes('17000') }.raises(ArgumentError) { "Please specify a time of day as 'hhmm', was given '17000' instead" }
    asserts("raises an exception for a time-of-day string that has an invalid hour") { topic.get_hours_and_minutes('2403') }.raises(ArgumentError) { "Please specify a time in hours ranging from 0 to 23, was given '24' in '2403' instead" }
    asserts("raises an exception for a time-of-day string that has an invalid minute") { topic.get_hours_and_minutes('1360') }.raises(ArgumentError) { "Please specify a time in minutes ranging from 0 to 59, was given '60' in '1360' instead" }
  end

end