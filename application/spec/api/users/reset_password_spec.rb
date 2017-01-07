describe 'PATCH /api/users/:id/reset_password' do
  before { stub_const("ConfirmResetPasswordJob", double(perform_async: nil)) }
  let(:user) { create(:user, reset_password: code, reset_password_expiration: expiration) }
  let(:expiration) { Time.now + 30.minutes }
  let(:code) { '0123456789' }

  context 'when using valid attributes and code' do
    let(:body) do
      {
        new_password:      "mynewpassword",
        confirm_password:  "mynewpassword",
        verification_code: code
      }
    end

    it 'resets the password', :aggregate_failures do
      expect(ConfirmResetPasswordJob).to receive(:perform_async).with(user.email)

      expect { patch "api/v1.0/users/#{user.id}/reset_password", body }.to change { user.refresh.password_digest }

      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
  end

  context 'when using an invalid code' do
    let(:body) do
      {
        new_password:      "mynewpassword",
        confirm_password:  "mynewpassword",
        verification_code: "FFFFFFFF"
      }
    end

    it "doesn't reset the password", :aggregate_failures do
      patch "api/v1.0/users/#{user.id}/reset_password", body

      expect(response).to be_unauthorized
      expect(response_body).to include(error_type: 'unauthorized')
    end
  end

  context 'when using an expired code' do
    let(:body) do
      {
        new_password:      "mynewpassword",
        confirm_password:  "mynewpassword",
        verification_code: code
      }
    end
    let(:expiration) { Time.now - 1.hour }

    it "doesn't reset the password", :aggregate_failures do
      patch "api/v1.0/users/#{user.id}/reset_password", body

      expect(response).to be_unauthorized
      expect(response_body).to include(error_type: 'unauthorized')
    end
  end

  context 'when using invalid attributes' do
    let(:body) do
      {
        new_password:     "mynewpassword",
        confirm_password: "otherpassword",
        verification_code: code
      }
    end

    it "doesn't reset the password", :aggregate_failures do
      expect(ConfirmResetPasswordJob).to_not receive(:perform_async)

      expect { patch "api/v1.0/users/#{user.id}/reset_password", body }.to_not change { user.refresh.password_digest }

      expect(response).to be_unprocessable
      expect(response_body).to include(error_type: 'invalid')
    end
  end
end
