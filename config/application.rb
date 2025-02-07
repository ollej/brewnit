require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Brewnit
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.time_zone = 'Europe/Stockholm'

    config.i18n.default_locale = :sv
    #config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.sass.preferred_syntax = :scss
    config.sass.line_comments = false
    config.sass.cache = false

    config.active_record.schema_format = :sql

    config.action_dispatch.rescue_responses.merge!(
      'AuthorizationException' => :unauthorized
    )

    config.secrets = config_for(:secrets)

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.logger = Rails.logger
    config.action_mailer.default_options = {
      charset: 'UTF-8',
      from: 'brewmaster@brygglogg.se',
      reply_to: 'brewmaster@brygglogg.se',
    }
    config.action_mailer.smtp_settings = {
      address:              'live.smtp.mailtrap.io',
      port:                 587,
      domain:               'brygglogg.se',
      user_name:            'api',
      password:             Rails.configuration.secrets.smtp_password,
      authentication:       :login,
      enable_starttls_auto: true
    }

    config.after_initialize do
      Rails.application.routes.default_url_options = config.action_mailer.default_url_options
    end

    config.middleware.use Rack::Attack
  end
end
