class UserValidator
  include Hanami::Validations
  predicates FormPredicates

  validations do
    required("email"){ str? }
    optional("born_on"){ datetime_str? }
  end
end