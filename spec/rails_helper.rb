# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'active_record/acts_as/matchers'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'paper_trail/frameworks/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
require "#{Rails.root}/app/models/user.rb"

Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false, window_size: [1025, 768])
end

SimpleCov.minimum_coverage 40

RSpec.configure do |config|
  config.include SessionHelper
  config.include RequestHelper, type: :request
  config.include FeatureHelper, type: :feature

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include ActionDispatch::TestProcess

  FactoryGirl::SyntaxRunner.class_eval do
    include ActionDispatch::TestProcess
  end
end
