# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_journalist_session', domain: ENV["APP_HOST"]