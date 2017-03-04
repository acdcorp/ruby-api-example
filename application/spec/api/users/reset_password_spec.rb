require 'spec_helper'

describe 'PATCH /api/users/:id/reset_password' do

  let!(:user) { create(:user, password: 'oldpass') }
  let(:user_id) { user.id }

  context "with valid params" do

    let(:params) { { new_password: 'new_pass123', confirm_password: 'new_pass123'} }

    it "should reset password" do
      patch "api/v1.0/users/#{user_id}/reset_password", params

      user = Api::Models::User.where(id: user_id).first

      expect(response_status).to eq(200)
      expect(response_body[:errors]).not_to be_present
      expect(user.reload.password).not_to eq('oldpass')
      expect(user.password).to eq(params[:new_password])
    end

    it 'should enqueue reset password mailer' do
      expect {
        patch "api/v1.0/users/#{user_id}/reset_password", params
      }.to change(Api::ResetPasswordMailer.jobs, :size).by(1)
    end

  end

  context "with invalid params" do

    let(:params) { { new_password: 'notmatch', confirm_password: 'new_pass123'} }

    it "should return an error" do
      patch "api/v1.0/users/#{user.id}/reset_password", params

      errors = response_body[:errors]
      expect(response_status).to eq(422)
      expect(errors).to be_present
      expect(errors[:confirm_password]).to be_present
      expect(user.password).to eq('oldpass')
    end

    it 'should not enqueue reset password mailer' do
      expect {
        patch "api/v1.0/users/#{user_id}/reset_password", params
      }.to change(Api::ResetPasswordMailer.jobs, :size).by(0)
    end

  end


end
