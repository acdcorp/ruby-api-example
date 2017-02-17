require 'spec_helper'

describe 'PUT /api/users/:id' do
  before do
    @user = create(:user, email: 'test_user@test.com', password: 'password')
  end

  it "should update a user" do
    put "api/v1.0/users/#{@user.id}", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => @user.token }
    expect(response_body[:user][:full_name]).to eq "Lionel Messi"
    expect(Api::Models::User.find(id: @user.id).full_name).to eq "Lionel Messi"
  end

  it "should return validation errors" do
    put "api/v1.0/users/#{@user.id}", { user: {email: "wrong_email"} }, {'X-Auth-Token' => @user.token }
    
    errors = response_body[:errors]
    expect(errors).not_to be_empty
    expect(errors[:email].first).to eq "must be an email"
  end

  it "should reject a request with the wrong token" do
    put "api/v1.0/users/#{@user.id}", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => '123345677' }
    expect(last_response.status).to eq 401
    expect(response_body[:error]).to eq "Unauthorized request"
  end

  it "should reject a request with another user's token" do
    another_user = create(:user)
    put "api/v1.0/users/#{@user.id}", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => another_user.token }
    expect(last_response.status).to eq 401
    expect(response_body[:error]).to eq "Unauthorized request"
  end
end
