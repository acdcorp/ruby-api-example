class Api
  module Validators
    class UserSignin
      include Hanami::Validations
      predicates FormPredicates

      validations do
        required('email') { email? }
        required('password') { filled? & str? }
      end
    end
  end
end
