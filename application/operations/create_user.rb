class Api
  class CreateUser < UserOperation
    def call(params)
      val = UserValidator.new(params).validate

      if val.success?
        user = Models::User.create(val.output)
        ConfirmNewUserJob.perform_async(user.email)
        success(user)
      else
        failure(error_type: :invalid, messages: val.messages)
      end
    end
  end
end
