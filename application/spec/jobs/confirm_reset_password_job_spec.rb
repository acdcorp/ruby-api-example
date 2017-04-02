describe ConfirmResetPasswordJob do
  describe "#perform" do
    let(:email) { "user@test.com" }
    before { ConfirmResetPasswordJob.perform_async(email) }

    it "sends an email notifying the password change" do
      is_expected.to have_sent_email.to(email)
                                    .from("admin@sample.com")
                                    .with_subject("Api Example: password reset")
                                    .with_body("Your password was succesfully updated")
    end
  end
end
