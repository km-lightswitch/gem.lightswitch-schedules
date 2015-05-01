Gem::Specification.new do |s|

  s.name                = 'lightswitch-schedules'
  s.version             = '0.0.2'
  s.date                = '2015-04-19'
  s.summary             = 'Create schedules for use in lightswitch'
  s.description         = 'Create and persist schedules (such as daily and weekly) that lightswitch can use to turn instances on and off'
  s.authors             = ['Krishnan M']
  s.email               = 'km@krishnanm.com'
  s.files               = Dir['lib/**/*.rb']
  s.add_development_dependency 'riot'
  s.add_runtime_dependency 'data_mapper'
  s.add_runtime_dependency 'dm-sqlite-adapter'
  s.homepage            = 'http://rubygems.org/gems/lightswitch-schedules'
  s.license             = 'MIT'

end
