require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Brewnit
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Europe/Stockholm'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :sv
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib/errors')
    config.autoload_paths << Rails.root.join('/app/validators')
    config.autoload_paths << Rails.root.join('/app/presenters')

    config.sass.preferred_syntax = :scss
    config.sass.line_comments = false
    config.sass.cache = false

    config.active_record.schema_format = :sql

    config.action_dispatch.rescue_responses.merge!(
      'AuthorizationException' => :unauthorized
    )

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
      address:              'mail.gandi.net',
      port:                 587,
      domain:               'brygglogg.se',
      user_name:            'smtp@brygglogg.se',
      password:             Rails.application.secrets.smtp_password,
      authentication:       :login,
      enable_starttls_auto: true
    }

    ActiveSupport.halt_callback_chains_on_return_false = false

    config.after_initialize do
      Rails.application.routes.default_url_options = config.action_mailer.default_url_options
    end

    config.middleware.use Rack::Attack
  end
end
