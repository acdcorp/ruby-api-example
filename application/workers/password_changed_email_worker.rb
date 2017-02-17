require 'sidekiq'
require_relative '../config/mail.rb'

Sidekiq.configure_server do |config|
  config.redis = { db: 1 }
end

Sidekiq.configure_client do |config|
  config.redis = { db: 1 }
end

class PasswordChangedEmailWorker
  include Sidekiq::Worker
  def perform(email)
    Mail.deliver do
      from     'no-reply@testapp.com'
      to       email
      subject  'password changed'
      body     "Your password has been changed"
    end
  end
end