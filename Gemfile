source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use sqlite3 as the database for Active Record
gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'devise', '3.2.0'
gem 'kaminari', '0.14.1'
gem 'redcarpet', '3.0.0'
gem 'haml-rails'
gem 'backbone-on-rails'

gem 'omniauth-github', '1.1.1'
gem 'github_api', '0.10.2'

gem 'omniauth-ruffnote', :github => 'pandeiro245/omniauth-ruffnote'
#gem 'ruffnote_api', :github => 'pandeiro245/ruffnote_api'
#gem 'ruffnote_api', :path => '/Users/[yourpath]/git/ruffnote_api'


group :development do
  gem 'guard-livereload', '2.0.0'
  gem 'guard-rspec', '4.0.3'
  gem 'quiet_assets', '1.0.2'
end

group :test do
  gem 'simplecov', '0.7.1', :require => false
  gem 'database_rewinder'
end

group :development, :test do
  gem 'rspec-rails', '2.14.0'
  gem 'factory_girl_rails', '4.3.0'
  gem 'spring', '0.9.0'
  gem 'spring-commands-rspec', '1.0.0', require: false
  gem "letter_opener", '1.1.2'
end
