# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.1'

gem 'sqlite3'         # database

gem 'puma', '~> 3.11' # app server

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
