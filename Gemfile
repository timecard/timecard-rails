source 'https://rubygems.org'

ruby '2.1.2'

gem 'rails', '4.1.6'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'devise', '3.2.0'
gem 'cancan'
gem 'kaminari', '0.14.1'
gem 'redcarpet', '3.0.0'
gem 'haml-rails'
gem 'backbone-on-rails'
gem 'omniauth-github', '~> 1.1.1'
gem 'github_api', '~> 0.12.0'
gem 'omniauth-ruffnote', :github => 'pandeiro245/omniauth-ruffnote'
gem 'ruffnote_api', :github => 'pandeiro245/ruffnote_api'
#gem 'ruffnote_api', :path => '/Users/[yourpath]/git/ruffnote_api'
gem 'mechanize'
gem 'exception_notification'
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'
gem 'grape'
gem 'grape-jbuilder'
gem 'websocket-rails'
gem 'public_activity'
gem 'chartkick', '~> 1.3.2'
gem 'time_diff', '~> 0.3.0'
gem 'pg'

# Configuration
gem 'rails_config'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'guard-konacha', '~> 1.0.5'
  gem 'quiet_assets', '1.0.2'
  gem 'erb2haml'
  gem 'spring'
  gem 'spring-commands-rspec', require: false
  gem 'rack-mini-profiler', '~> 0.9.2'
end

group :test do
  gem 'simplecov', '0.7.1', :require => false
  gem 'database_rewinder'
  gem 'coveralls', '~> 0.7.1', require: false
  gem 'webmock'
  gem 'timecop', '~> 0.7.1'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'factory_girl_rails', '~> 4.4.0'
  gem 'letter_opener', '~> 1.2.0'
  gem 'konacha'
  gem 'poltergeist'
  gem 'chai-jquery-rails'
  gem 'sinon-rails'
  gem 'mysql2'
end

group :doc do
  gem 'sdoc', require: false
end
