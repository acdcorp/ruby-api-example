class Api
  class ResetPasswordValidator < Operation::Validator
    validations do
      required(:new_password).filled(:str?)
      required(:confirm_password).filled(:str?)
      required(:verification_code).filled(:str?)

      rule(password_confirmation: [:new_password, :confirm_password]) do |new_password, confirm_password|
        new_password.eql?(confirm_password)
      end
    end
  end
end
