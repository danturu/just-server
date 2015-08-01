require File.expand_path("../boot", __FILE__)

require "active_model/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module JustServer
  class Application < Rails::Application
    VERSION = "0.1.0"

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += [config.root.join("lib")]

    # Configure default locale.
    config.i18n.default_locale = :en

    # Enable locale fallbacks for I18n.
    config.i18n.fallbacks = true

    # Skip validation of locale.
    config.i18n.enforce_available_locales = false

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Precompile fonts.
    config.assets.precompile += %w(*.woff2 *.eot *.ttf *.woff *.svg)

    # Use WebSocket middleware.
    config.middleware.use "MessagesMiddleware"
  end
end
