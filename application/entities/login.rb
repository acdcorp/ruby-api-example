class Api::Models::Login
  class Authorization < Grape::Entity
    expose :token, documentation: { desc: 'JWT Authorization Token' }
  end

  class Input < Grape::Entity
    expose :email, documentation: { desc: "User's Email", required: true }
    expose :password, documentation: { desc: "User's Password", required: true }
  end
end
