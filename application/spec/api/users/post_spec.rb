require 'spec_helper'

describe 'POST /api/users' do

  context "with valid params" do

    let(:user_params) { FactoryGirl.attributes_for(:user) }

    it do
      expect {
        post "api/v1.0/users", user_params
      }.to change{ Api::Models::User.count }.by(1)
    end

    it 'should create the user' do
      post "api/v1.0/users", user_params
      user = response_body[:user]
      expect(user[:id]).to be_present
      expect(user[:email]).to eq(user_params[:email])
    end

  end

  context "with invalid params" do

    let(:user_params) { { } }

    it do
      expect {
        post "api/v1.0/users", user_params
      }.not_to change{ Api::Models::User.count }
    end

    it 'should not create the user' do
      post "api/v1.0/users", user_params
      errors = response_body[:errors]
      expect(errors).to be_present
      expect(errors[:first_name]).to be_present
    end

  end
end
