class Api
  class NewResetPasswordCode < Operation
    def call(params)
      user = Models::User.with_pk!(params[:user_id])
      code = new_reset_password_code!(user)
      SendResetPasswordCodeJob.perform_async(user.email, code)
      success(user)
    end

    private

    def new_reset_password_code!(user)
      SecureRandom.hex(4).upcase.tap do |code|
        user.update(reset_password: code, reset_password_expiration: Time.now + 30.minutes)
      end
    end
  end
end
