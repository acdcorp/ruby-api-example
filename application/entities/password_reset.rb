class Api::Models::PasswordReset
  class Input < Grape::Entity
    expose :new_password, documentation: { desc: "User's password", required: true }
    expose :confirm_password, documentation: { desc: "Password confirmation", required: true }
    expose :verification_code, documentation: { desc: "Verification code", required: true }
  end
end
