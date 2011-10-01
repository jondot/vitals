$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "vitals/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "vitals"
  s.version     = Vitals::VERSION
  s.authors     = ["Dotan Nahum"]
  s.email       = ["jondotan@gmail.com"]
  s.homepage    = "http://blog.paracode.com"
  s.summary     = "A simple Rails 3 gem that reports ActiveSupport Notifications back to statsd"
  s.description = "A simple Rails 3 gem that reports ActiveSupport Notifications back to statsd"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency "statsd-ruby"
  s.add_development_dependency "sqlite3"
end
