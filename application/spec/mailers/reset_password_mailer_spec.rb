require 'spec_helper'

RSpec.describe Api::ResetPasswordMailer do

  before { Sidekiq::Testing.inline! }
  after  { Sidekiq::Testing.fake! }

  let!(:user) { create(:user) }

  before do
    described_class.perform_async(user.id)
  end

  it 'should send the email properly' do
    expect(last_mail).to have_sent_email.to(user.email).matching_subject(/password/i)
  end

  it "should send html part" do
    expect(last_mail.html_part).to be_present
  end

  it "should send text part" do
    expect(last_mail.text_part).to be_present
  end

end
