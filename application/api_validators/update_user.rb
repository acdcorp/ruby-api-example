class Api
  module Validators
    class UpdateUser
      include Hanami::Validations
      predicates FormPredicates

      validations do
        optional('first_name') { filled? & str? }
        optional('last_name') { filled? & str? }
        optional('email') { email? }
        optional('date_of_birth') { datetime_str? }
      end
    end
  end
end
