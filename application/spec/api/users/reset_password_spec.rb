require 'spec_helper'

describe 'PATCH /api/users/:id/reset_password' do
  before do
    @user = create(:user, password: '123456')
  end

  it "should update a user" do
    patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'password' }, {'X-Auth-Token' => @user.token }
    expect(response_body[:success]).to eq true
    expect(Api::Models::User.find(id: @user.id).password).to eq "password" 
  end

  it "should return validation errors" do
    patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'different' }, {'X-Auth-Token' => @user.token }
    
    errors = response_body[:errors]
    expect(errors).not_to be_empty
    expect(errors[:new_password_confirmation].first).to eq "must be equal to password"
  end

  it "should reject a request with the wrong token" do
    patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'password' }, {'X-Auth-Token' => '123345677' }
    expect(response_body[:error]).to eq "Unauthorized request"
  end

  it "should reject a request with another user's token" do
    another_user = create(:user)
    patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'password' }, {'X-Auth-Token' => another_user.token }
    expect(last_response.status).to eq 401
    expect(response_body[:error]).to eq "Unauthorized request"
  end

  it "should add a job to send welcome email" do
    expect{ patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'password' }, {'X-Auth-Token' => @user.token } }.to change{ PasswordChangedEmailWorker.jobs.size }.by(1)
  end

  it "should queue a job to send an email to the user's email" do
    patch "api/v1.0/users/#{@user.id}/reset_password", { new_password: 'password', new_password_confirmation: 'password' }, {'X-Auth-Token' => @user.token }

    expect(PasswordChangedEmailWorker.jobs.last["args"]).to eq [@user.email]
  end
end
