require 'spec_helper'

describe 'PUT /api/users/:id' do

  context "with valid params" do

    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:params) { FactoryGirl.attributes_for(:user, except: [:password]) }

    it 'should create the user' do
      put "api/v1.0/users/#{user_id}", params
      user = response_body[:user]
      expect(user[:id]).to eq(user_id)
      expect(user[:first_name]).to eq(params[:first_name])
      expect(user[:last_name]).to eq(params[:last_name])
      expect(user[:email]).to eq(params[:email])
      expect(user[:date_of_birth]).to eq(params[:date_of_birth])
    end

  end

end
