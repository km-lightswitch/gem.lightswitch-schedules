require_relative '../lib/lightswitch/schedules'
require_relative '../lib/lightswitch/models'

require 'data_mapper'
require 'dm-migrations'

DataMapper::Model.raise_on_save_failure = true

debug = false
DataMapper::Logger.new($stdout, :debug) if debug

DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.finalize
DataMapper.auto_migrate!

require 'riot'