class Api
  class Login < Operation
    def call(params)
      user = Models::User.first!(email: params[:email])

      if user.authenticate(params[:password])
        success(user)
      else
        failure(error_type: :unauthorized)
      end
    end
  end
end
