require 'spec_helper'

describe 'POST /api/users' do
  it 'should create a new user' do
    expect { post "api/v1.0/users", user: {
      first_name: 'juancho', last_name: 'polo', email: 'juancho@test.com', password: 'password', born_on: '1990-02-14'} 
    }.to change{ Api::Models::User.count }.by(1)
  end
end
