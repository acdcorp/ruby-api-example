class Api
  module Validators
    class CreateUser
      include Hanami::Validations
      predicates FormPredicates

      validations do
        required('first_name') { filled? & str? }
        required('last_name') { filled? & str? }
        required('email') { email? }
        required('password') { filled? & str? }
        optional('date_of_birth') { datetime_str? }
      end
    end
  end
end
