describe 'POST /api/users' do
  before { stub_const("ConfirmNewUserJob", double(perform_async: nil)) }

  context 'when using valid attributes' do
    let(:body) do
      {
        first_name: "John",
        last_name:  "Doe",
        password:   "mypassword",
        email:      "john@doe.com",
        born_on:    "1982-01-01 08:00:00 +0000"
      }
    end

    it 'creates a new user', :aggregate_failures do
      expect(ConfirmNewUserJob).to receive(:perform_async).with("john@doe.com")

      expect { post "api/v1.0/users", body }.to change(Api::Models::User, :count).by(1)

      expect(response).to be_created
      expect(response_body).to match(id: a_kind_of(Integer),
                                     first_name: "John",
                                     last_name: "Doe",
                                     email: "john@doe.com",
                                     born_on: "1982-01-01T08:00:00Z",
                                     created_at: match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/),
                                     updated_at: match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z/))
    end
  end

  context 'when using invalid attributes' do
    let(:body) do
      {
        first_name: "John",
        last_name:  "Doe",
        password:   "mypassword",
        email:      "not an email"
      }
    end

    it 'does not create a new user', :aggregate_failures do
      expect(ConfirmNewUserJob).to_not receive(:perform_async)

      expect { post "api/v1.0/users", body }.to_not change(Api::Models::User, :count)

      expect(response).to be_unprocessable
      expect(response_body).to include(error_type: 'invalid')
    end
  end
end
