require_relative '../lib/lightswitch/schedules'
require_relative '../lib/lightswitch/time_utility'
require_relative '../lib/lightswitch/persistence'

require 'data_mapper'
require 'dm-migrations'

DataMapper::Model.raise_on_save_failure = true
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_migrate!

require 'riot'