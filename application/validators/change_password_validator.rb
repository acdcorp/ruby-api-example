class ChangePasswordValidator
  include Hanami::Validations
  predicates FormPredicates

  validations do
    required(:new_password).filled.confirmation
  end
end