class Api
  class ResetPassword < UserOperation
    def call(params)
      user = user_for(params)
      val  = ResetPasswordValidator.new(params).validate

      if !valid_reset_password_code?(user, val.output[:verification_code])
        failure(error_type: :unauthorized)
      elsif val.failure?
        failure(error_type: :invalid, errors: val.messages)
      else
        user.update(password: val.output[:new_password])
        ConfirmResetPasswordJob.perform_async(user.email)
        success(user)
      end
    end

    private

    def valid_reset_password_code?(user, code)
      code && code == user.reset_password && Time.now <= user.reset_password_expiration
    end
  end
end
