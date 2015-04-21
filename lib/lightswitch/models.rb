require 'data_mapper'
require_relative 'schedule_mixins'

module Lightswitch

  class ScheduleCollection
    include DataMapper::Resource, ScheduleCollectionMixin

    property :id, Serial
    property :name, String, :required => true

    has n, :schedules

    def to_s
      "Schedule collection #{name}" + (schedules.empty? ? "" : " with schedules: " + schedules.collect(&:to_s).join("\n"))
    end

  end


  class Schedule
    include DataMapper::Resource, ScheduleMixin

    property :id, Serial
    property :start_hour, Integer, :required => true
    property :start_minutes, Integer, :required => true
    property :end_hour, Integer
    property :end_minutes, Integer

    belongs_to :schedule_collection, :required => false

  end

end