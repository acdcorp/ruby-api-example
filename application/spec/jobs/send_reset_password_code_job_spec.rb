describe SendResetPasswordCodeJob do
  describe "#perform" do
    let(:email) { "user@test.com" }
    let(:code) { "0011AABBCC" }
    before { SendResetPasswordCodeJob.perform_async(email, code) }

    it "sends an email notifying the password reset code" do
      is_expected.to have_sent_email.to(email)
                                    .from("admin@sample.com")
                                    .with_subject("Api Example: password reset code")
                                    .with_body("You will be able to reset your password within the next 30 minutes using this code: #{code}")
    end
  end
end
