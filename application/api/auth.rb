class Api
  namespace :auth do

    desc 'Generates a new authentication token', entity: Models::Login::Entity
    post 'login' do
      user = Models::User[email: params[:email]]
      if user.authenticate(params[:password])
        api_response(token: auth_token_for(user))
      else
        api_response(:unauthorized)
      end
    end

    desc 'Generates a new reset password code' do
      success code: 204
    end
    post 'reset_password_code/:user_id' do
      user = Models::User.with_pk!(params[:user_id])
      code = user.update_reset_password_code!

      SendResetPasswordCodeJob.perform_async(user.email, code)

      body false
    end

  end
end
