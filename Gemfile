# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails'

gem 'sqlite3' # database

gem 'puma', '~> 4.3' # app server

# gem 'jbuilder', '~> 2.5' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'bootsnap', '>= 1.1.0', require: false # Reduces boot times through caching

group :development, :test do
  gem 'pry-byebug' # integrate proper debugging
  gem 'pry-rails'  # replace IRB

  gem 'rubocop' # go down in style, consistently

  gem 'fabrication' # replace fixtures
  gem 'rspec-rails' # essentially anything but mintest or test/unit
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end
