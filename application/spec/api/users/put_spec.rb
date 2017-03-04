require 'spec_helper'

describe 'PUT /api/users/:id', :type => :request do

  let(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:params) { FactoryGirl.attributes_for(:user, except: [:password]) }

  context "Protected endpoint" do
    it 'doesnt allow unauthorized requests' do
      put "api/v1.0/users/#{user_id}", params
      expect(response_body[:error_type]).to eq('not_authorized')
    end
  end

  context "with valid params" do

    let(:token) do
      payload = { email: user.email }
      JWT.encode(payload, HMAC_SECRET)
    end

    let(:headers) { { 'HTTP_AUTHORIZATION' => token} }

    it 'should update the user' do
      put "api/v1.0/users/#{user_id}", params, headers
      user = response_body[:user]
      expect(user[:id]).to eq(user_id)
      expect(user[:first_name]).to eq(params[:first_name])
      expect(user[:last_name]).to eq(params[:last_name])
      expect(user[:email]).to eq(params[:email])
      expect(user[:date_of_birth]).to eq(params[:date_of_birth])
    end

  end

  context "update another user" do

    let(:another_user) { create(:user) }
    let(:user_id) { another_user.id }

    let(:token) do
      payload = { email: user.email }
      JWT.encode(payload, HMAC_SECRET)
    end

    let(:headers) { { 'HTTP_AUTHORIZATION' => token} }

    it 'should NOT update another user' do
      put "api/v1.0/users/#{user_id}", params, headers
      expect(response_body[:error_type]).to eq('forbidden')
    end

  end

end
