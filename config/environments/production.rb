# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

RAILS_GEM_VERSION = '2.1.0'


config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.perform_deliveries = true

ActionMailer::Base.smtp_settings[:address] = "sumec.onesim.net"
ActionMailer::Base.smtp_settings[:domain] = "bolen.onesim.net"
ExceptionNotifier.exception_recipients = %w(jakub.hozak@gmail.com)

# to keep sensitive information out of SVN
require "#{RAILS_ROOT}/config/volant_access.rb"
require "#{RAILS_ROOT}/config/google_maps_access.rb"
