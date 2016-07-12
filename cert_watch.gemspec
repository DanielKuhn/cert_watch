$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'cert_watch/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'cert_watch'
  s.version     = CertWatch::VERSION
  s.authors     = ['Tim Fischbach']
  s.email       = ['tfischbach@codevise.de']
  s.summary     = 'Rails engine for automatically renewing SSL certificates.'
  s.homepage    = 'http://gitlab.codevise.de/codevise/cert_watch'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.6'

  s.add_development_dependency 'sqlite3'

  # Testing framework
  s.add_development_dependency 'rspec-rails', '~> 3.5'

  # Fixture data
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'

  # Freeze time in tests
  s.add_development_dependency 'timecop', '~> 0.7.1'

  # Dummy Rails app helper
  s.add_development_dependency 'combustion', '~> 0.5.4'

  # Database for test application
  s.add_development_dependency 'sqlite3'
end