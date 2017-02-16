require 'spec_helper'

describe WelcomeEmailWorker do
  before do
    Mail.defaults do
      delivery_method :test
    end
    Sidekiq::Testing.inline!
  end

  it "should send an email" do
    WelcomeEmailWorker.perform_async("juancho@test.com")
    mail = Mail::TestMailer.deliveries.last
    expect(mail.to).to eq ["juancho@test.com"]
    expect(mail.subject).to eq "Welcome to our app"
    expect(mail.body.to_s).to eq "Welcome to this app"
  end
end