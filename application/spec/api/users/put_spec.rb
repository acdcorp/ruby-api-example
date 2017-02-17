require 'spec_helper'

describe 'PUT /api/users' do
  before do
    @user = create(:user, email: 'test_user@test.com', password: 'password')
  end

  xit "should update a user" do
    put "api/v1.0/users/#{@user.id}", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => @user.token }
    expect(response_body[:user][:ful_name]).to eq "Lionel Messi"
  end

  it "should reject a request with the wrong token" do
    put "api/v1.0/users/#{@user.id}", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => '123345677' }
    expect(last_response.status).to eq 401
    expect(response_body[:error]).to eq "Unauthorized request"
  end
end
