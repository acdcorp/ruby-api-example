class UserCreationValidator
  include Hanami::Validations
  predicates FormPredicates

  validations do
    optional("first_name"){ str? }
    optional("last_name"){ str? }
    optional("born_on"){ datetime_str? }
    optional("email"){ email? }
  end
end