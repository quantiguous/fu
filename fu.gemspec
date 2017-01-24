$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'fu/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'fu'
  s.version     = Fu::VERSION
  s.authors     = ['Lavanya Ramamoorthy']
  s.email       = ['lavanya.ramamoorthy@quantiguous.com']
  s.homepage    = 'http://rubygems.org/gems/fu'
  s.summary     = 'File Upload Framework'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'haml-rails'
  s.add_dependency 'will_paginate'
  s.add_dependency 'net-scp'
  s.add_dependency 'carrierwave', '0.11.2'
  s.add_dependency 'responders', '~> 2.0'
  s.add_dependency 'unscoped_associations'
  s.add_dependency 'simple_form'
  s.add_dependency 'lazy_columns'
  s.add_dependency 'pundit'
  s.add_dependency 'faraday'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails', '3.5.0'
  s.add_development_dependency 'factory_girl', '4.5.0'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'dotenv-rails'
  s.add_development_dependency 'jquery-rails'
end
