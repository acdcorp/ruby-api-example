describe 'PUT /api/users/:id' do
  let!(:user) { create(:user) }

  context 'when not logged in' do
    it 'does not update existing user', :aggregate_failures do
      put "api/v1.0/users/#{user.id}", {}

      expect(response).to be_forbidden
      expect(response_body).to include(error_type: 'forbidden', errors: { reason: "Permission denied" })
    end
  end

  context 'when logged in, editing your own user' do
    before { login_as user }

    context 'and using valid attributes' do
      let(:body) do
        {
          first_name: "Jane",
          last_name:  "Doe",
          password:   "mypassword",
          email:      "jane@doe.com",
          born_on:    ""
        }
      end

      it 'updates existing user', :aggregate_failures do
        put "api/v1.0/users/#{user.id}", body

        expect(response).to be_ok
        expect(response_body).to match(id: user.id,
                                       first_name: "Jane",
                                       last_name: "Doe",
                                       email: "jane@doe.com",
                                       born_on: nil,
                                       created_at: match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/),
                                       updated_at: match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/))
      end
    end

    context 'and using invalid attributes' do
      let(:body) do
        {
          first_name: "Jane",
          last_name:  "",
          password:   "mypassword",
          email:      "jane@doe.com",
          born_on:    "1984-01-01 08:00:00 +0000"
        }
      end

      it 'does not update existing user', :aggregate_failures do
        put "api/v1.0/users/#{user.id}", body

        expect(response).to be_unprocessable
        expect(response_body).to include(error_type: 'invalid')
      end
    end
  end

  context 'when logged in and editing another user' do
    before { login_as user }
    let!(:other_user) { create(:user) }

    it 'does not create a new user', :aggregate_failures do
      put "api/v1.0/users/#{other_user.id}", {}

      expect(response).to be_forbidden
      expect(response_body).to include(error_type: 'forbidden', errors: { reason: "Permission denied" })
    end
  end
end
