describe 'GET /api/users' do
  before :all do
    @u1 = create :user
    @u2 = create :user
  end

  it 'lists all users' do
    get "api/v1.0/users"

    emails = response_body[:data].map{ |x| x[:email] }
    expect(emails).to include @u1.email
    expect(emails).to include @u2.email
  end
end
