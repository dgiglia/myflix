source 'https://rubygems.org'
ruby '2.1.2'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'bootstrap_form'
gem 'bcrypt'
gem "nested_form"
gem "sidekiq"
gem "unicorn"
gem "sentry-raven"
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'stripe'
gem 'draper'
gem 'stripe_event'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email', github: 'dockyard/capybara-email'
  gem 'launchy'
  gem 'vcr', '2.9.3'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'poltergeist'
end

group :production, :staging do
  gem 'carrierwave-aws'
  gem 'rails_12factor'
end

