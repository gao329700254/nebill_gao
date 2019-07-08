require_relative 'boot'

require "csv"
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Nebill
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ja
    config.time_zone = 'Tokyo'

    config.autoload_paths += %W(#{config.root}/lib)
    config.paths['config/routes.rb'].concat Dir[Rails.root.join('config/routes/**/*.rb')]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.annotations.register_extensions('scss')   { |annotation| %r{//\s*(#{annotation}):?\s*(.*?)$} }
    config.annotations.register_extensions('slim')   { |annotation|  %r{/\s*(#{annotation}):?\s*(.*?)$} }
    config.annotations.register_extensions('coffee') { |annotation|    /#\s*(#{annotation}):?\s*(.*?)$/ }
    config.assets.precompile += %w( pdf/expense.css )
  end
end
