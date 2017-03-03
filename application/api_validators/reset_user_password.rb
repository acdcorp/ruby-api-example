class Api
  module Validators
    class ResetUserPassword

      include Hanami::Validations
      predicates FormPredicates

      validations do
        required('new_password').filled(:str?)
        required('confirm_password').filled(:str?)

        rule(password_doesnt_match: ['new_password', 'confirm_password']) do |new_password, confirm_password|
          new_password.eql?(confirm_password)
        end
      end

    end
  end
end
