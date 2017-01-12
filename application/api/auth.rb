class Api
  namespace :auth do

    desc 'Generates a new authentication token',
      entity: Models::Login::Authorization,
      params: Models::Login::Input.documentation_in_body,
      failure: [ { code: 403, message: 'Unauthorized' } ]
    post 'login' do
      Login.(params) do
        ok   { |user|   { token: auth_token_for(user) } }
        fail { |errors| api_response errors }
      end
    end

    desc 'Generates a new reset password code',
      success: { code: 204 }
    post 'reset_password_code/:user_id' do
      NewResetPasswordCode.(params)
      body false
    end

  end
end
