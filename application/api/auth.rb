class Api
  namespace :auth do

    desc 'Generates a new authentication token',
      entity: Models::Login::Authorization,
      params: Models::Login::Input.documentation_in_body,
      failure: [ { code: 403, message: 'Unauthorized' } ]
    post 'login' do
      user = Models::User[email: params[:email]]
      if user.authenticate(params[:password])
        { token: auth_token_for(user) }
      else
        api_response(error_type: :unauthorized, errors: { reason: "Invalid credentials" })
      end
    end

    desc 'Generates a new reset password code',
      success: { code: 204 }
    post 'reset_password_code/:user_id' do
      user = Models::User.with_pk!(params[:user_id])
      code = user.update_reset_password_code!

      SendResetPasswordCodeJob.perform_async(user.email, code)

      body false
    end

  end
end
