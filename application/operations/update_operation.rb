class Api
  class UpdateUser < UserOperation
    def initialize(current_user)
      @current_user = current_user
    end

    def call(params)
      user = user_for(params)
      val  = UserValidator.new(params).validate

      if !can_edit?(user)
        failure(error_type: :forbidden)
      elsif val.failure?
        failure(error_type: :invalid, messages: val.messages)
      else
        user.update(val.output)
        success(user)
      end
    end

    private

    def can_edit?(user)
      @current_user&.can?(:edit, user)
    end
  end
end
