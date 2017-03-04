require 'spec_helper'

describe 'POST /api/users/signin' do

  let(:user) { create(:user, password: 'mypass123') }

  context "with valid params" do

    let(:credentials) { { email: user.email, password: 'mypass123' } }

    it "should deliver user's token" do
      post "api/v1.0/users/signin", credentials
      expect(response_status).to eq(200)
      expect(response_body[:token]).to be_present
    end

  end

  context "with invalid params" do

    let(:user_email) { user.email }
    let(:user_password) { 'mypass123' }
    let(:bad_credentials) { { email:user_email, password: user_password } }

    context "wrong password" do

      let(:user_password) { 'anotherpass' }

      it 'should return unauthorized request' do
        post "api/v1.0/users/signin", bad_credentials
        expect(response_status).to eq(401)
        expect(response_body[:error_type]).to eq('unauthorized')
      end

    end

    context "wrong email" do

      let(:user_email) { 'another@email.com' }

      it 'should return unauthorized request' do
        post "api/v1.0/users/signin", bad_credentials
        expect(response_status).to eq(401)
        expect(response_body[:error_type]).to eq('unauthorized')
      end

    end

  end
end
