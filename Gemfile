# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 6.1.6"

gem "mysql2", "~> 0.5"

gem "puma", "~> 5.0"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"

gem "webpacker", "~> 5.0"

gem "turbolinks", "~> 5"

gem "jbuilder", "~> 2.7"

gem "bootsnap", ">= 1.4.4", require: false

source "https://rubygems.org"
gem "bootstrap-sass", "3.4.1"
gem "jquery-rails"
gem "sass-rails", ">= 6"

gem "rubocop"

gem "bcrypt", "~> 3.1.7"

gem "config"

gem "importmap-rails"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "string"
  gem "web-console", ">= 4.1.0"
end

group :test do
  gem "capybara", ">= 3.26"
  gem "selenium-webdriver", ">= 4.0.0.rc1"
  gem "webdrivers", "= 5.3.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
