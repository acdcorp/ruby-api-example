require 'spec_helper'

describe 'PUT /api/users' do
  before do
    @user = create(:user, email: 'test_user@test.com', password: 'password')
  end

  it "should update a user" do
    put "api/v1.0/users/:id", { user: {first_name: "Lionel", last_name: "Messi"} }, {'X-Auth-Token' => @user.token }

  end
end
