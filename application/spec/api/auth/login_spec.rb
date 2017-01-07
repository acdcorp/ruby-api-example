describe 'POST /api/auth/login' do
  let(:password) { '123456' }
  let(:user) { create(:user, password: password) }

  context "when the password is correct" do
    let(:body) do
      {
        email: user.email,
        password: password
      }
    end

    let(:token_payload) { JWT.decode(response_body[:token], HMAC_SECRET, true, algorithm: 'HS256')[0] }
    let!(:send_time) { Time.now }

    it 'returns a JWT token', :aggregate_failures do
      post "api/v1.0/auth/login", body

      expect(response).to be_successful
      expect(token_payload).to include('iss' => 'ruby-api-example', 'user_id' => user.id)
      expect(token_payload['exp']).to be_within(5).of(send_time.to_i + 4.hours)
    end
  end

  context "when the password is not correct" do
    let(:body) do
      {
        email: user.email,
        password: "wrong password"
      }
    end

    it 'returns a JWT token', :aggregate_failures do
      post "api/v1.0/auth/login", body

      expect(response).to be_unauthorized
      expect(response_body).to include(error_type: 'unauthorized', errors: {reason: 'Invalid credentials'})
    end

  end
end
