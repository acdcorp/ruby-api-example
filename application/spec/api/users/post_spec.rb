require 'spec_helper'

describe 'POST /api/users' do

  context "with valid params" do

    let(:user_params) { FactoryGirl.attributes_for(:user) }

    it 'should create the user' do
      post "api/v1.0/users", user_params
      user = response_body[:user]
      expect(user[:id]).to be_present
      expect(user[:email]).to eq(user_params[:email])
    end

  end
end
