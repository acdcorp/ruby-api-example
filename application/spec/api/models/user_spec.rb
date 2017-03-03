require 'spec_helper'

describe Api::Models::User do

  describe "#password" do

    let(:user) { create(:user, password: 'test123') }

    it "should set encrypted_password" do
      expect(user.encrypted_password).to be_present
      expect(user.encrypted_password).not_to eq('test123')
    end

    it "should delegate comparison to BCrypt library" do
      expect(user.password.class).to eq(BCrypt::Password)
      expect(user.password).to eq('test123')
    end

  end


end
