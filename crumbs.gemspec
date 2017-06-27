$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'crumbs/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'crumbs'
  s.version     = Crumbs::VERSION
  s.authors     = ['mmontossi']
  s.email       = ['mmontossi@museways.com']
  s.homepage    = 'https://github.com/mmontossi/crumbs'
  s.summary     = 'Crumbs for rails.'
  s.description = 'Handy crumbs variable for rails views.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1'

  s.add_development_dependency 'pg', '~> 0.21'
end
