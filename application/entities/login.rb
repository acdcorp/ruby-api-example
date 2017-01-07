class Api::Models::Login
  class Entity < Grape::Entity
    expose :email, documentation: { desc: "User's email", required: true }
    expose :password, documentation: { desc: "User's password", required: true }
  end
end
