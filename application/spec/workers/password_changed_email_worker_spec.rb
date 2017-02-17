require 'spec_helper'

describe PasswordChangedEmailWorker do
  before do
    Mail.defaults do
      delivery_method :test
    end
    Sidekiq::Testing.inline!
  end

  it "should send an email" do
    PasswordChangedEmailWorker.perform_async("juancho@test.com")
    mail = Mail::TestMailer.deliveries.last
    expect(mail.to).to eq ["juancho@test.com"]
    expect(mail.subject).to eq "password changed"
    expect(mail.body.to_s).to eq "Your password has been changed"
  end
end