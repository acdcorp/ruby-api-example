class UserValidator
  include Hanami::Validations
  predicates FormPredicates

  validations do
    required("first_name"){ str? }
    required("first_name"){ str? }
    required("password"){ str? }
    required("email"){ email? }
    optional("born_on"){ datetime_str? }
  end
end