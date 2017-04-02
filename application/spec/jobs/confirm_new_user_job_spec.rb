describe ConfirmNewUserJob do
  describe "#perform" do
    let(:email) { "user@test.com" }
    before { ConfirmNewUserJob.perform_async(email) }

    it "sends an email notifying the new user" do
      is_expected.to have_sent_email.to(email)
                                    .from("admin@sample.com")
                                    .with_subject("Api Example: new user")
                                    .with_body("Your account was successfully created")
    end
  end
end
