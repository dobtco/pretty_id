$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pretty_id/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "pretty_id"
  s.version = PrettyId::VERSION

  s.required_ruby_version = Gem::Requirement.new('>= 2.0.0')
  s.authors = ['Adam Becker']
  s.summary = 'Add random, unique "pretty" ids to your ActiveRecord models.'
  s.email = 'adam@dobt.co'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {features,spec}/*`.split("\n")

  s.homepage = 'http://github.com/dobtco/pretty_id'

  s.add_dependency 'rails'

  s.add_development_dependency 'appraisal', '1.0.0'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end
