$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resque-queueable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resque-queueable"
  s.version     = ResqueQueueable::VERSION
  s.authors     = ["Kevin McPhillips"]
  s.email       = ["github@kevinmcphillips.ca"]
  s.homepage    = "http://github.com/kimos/resque-queueable"
  s.summary     = "Adds an easy interface to an Active Record model defined as queueable to enque any methods."
  s.description = "An Active Record model can be defined as 'queueable'. That adds extensions to add any method to the queue that exists on the method instance."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.0"
  s.add_dependency "activerecord", "~> 3.0"
  s.add_dependency "activesupport", "~> 3.0"
  s.add_dependency "resque"

  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
end
