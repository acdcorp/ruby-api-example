require 'spec_helper'

describe 'POST /api/users' do
  let(:user_attributes){ attributes_for(:user) }

  it 'should create a new user' do
    expect { post "api/v1.0/users", user: user_attributes }.to change{ Api::Models::User.count }.by(1)
  end

  it "should return the created user" do
    post "api/v1.0/users", user: user_attributes
    user = response_body[:user]
    expect(user[:first_name]).to eq(user_attributes[:first_name])
    expect(user[:last_name]).to eq(user_attributes[:last_name])
    expect(user[:full_name]).to eq("#{user_attributes[:first_name]} #{user_attributes[:last_name]}")
  end

  it "should return validation errors" do
    user_attributes[:email] = "juanchopolo@"
    post "api/v1.0/users", user: user_attributes
    
    errors = response_body[:errors]
    expect(errors).not_to be_empty
    expect(errors[:email].first).to eq "must be an email"
  end

  it "should add a job to send welcome email" do
    expect{ post "api/v1.0/users", user: user_attributes }.to change{ WelcomeEmailWorker.jobs.size }.by(1)
  end

  it "should queue a job to send an email to the user's email" do
    post "api/v1.0/users", user: user_attributes

    expect(WelcomeEmailWorker.jobs.last["args"]).to eq [user_attributes[:email]]
  end
end
