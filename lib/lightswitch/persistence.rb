require 'data_mapper'

module Lightswitch

  class ScheduleCollection
    include DataMapper::Resource

    property :id, Serial
    has n, :schedules

    def to_s
      "Schedule collection" + (schedules.empty? ? "" : " with schedules: " + schedules.collect(&:to_s).join("\n"))
    end

  end


  class Schedule
    include DataMapper::Resource

    property :id, Serial
    property :start_hour, Integer, :required => true
    property :start_minutes, Integer, :required => true
    property :end_hour, Integer
    property :end_minutes, Integer

    belongs_to :schedule_collection, :required => false

  end

end