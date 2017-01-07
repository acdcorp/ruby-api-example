describe 'POST /api/auth/reset_password_code/:user_id' do
  before { stub_const("SendResetPasswordCodeJob", double(perform_async: nil)) }
  let!(:user) { create(:user) }
  let!(:send_time) { Time.now }

  it 'sets a reset password verification code', :aggregate_failures do
    expect(SendResetPasswordCodeJob).to receive(:perform_async).with(user.email, match(/[A-F0-9]{10}/))

    post "api/v1.0/auth/reset_password_code/#{user.id}"

    user.refresh
    expect(user.reset_password).to match(/[A-F0-9]{10}/)
    expect(user.reset_password_expiration).to be_within(5.seconds).of(send_time + 30.minutes)

    expect(response.status).to eq(204)
    expect(response.body).to be_empty
  end
end
