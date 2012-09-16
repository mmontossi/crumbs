$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_breadcrumbs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-breadcrumbs"
  s.version     = RailsBreadcrumbs::VERSION
  s.authors     = ["Mattways"]
  s.email       = ["contact@mattways.com"]
  s.homepage    = "https://github.com/mattways/rails-breadcrumbs"
  s.summary     = "Breadcrumbs for Rails."
  s.description = "Adds a handy breadcrumbs variable available in views with almost no configuration."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.8"

  s.add_development_dependency "sqlite3"
end
