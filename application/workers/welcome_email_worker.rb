require 'sidekiq'
require_relative '../config/mail.rb'

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

class WelcomeEmailWorker
  include Sidekiq::Worker
  def perform(email)
    Mail.deliver do
      from     'no-reply@testapp.com'
      to       email
      subject  'Welcome to our app'
      body     "Welcome to this app"
    end
  end
end