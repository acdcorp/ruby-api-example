class Api
  resource :users do
    params do
      includes :basic_search
    end

    get do
      users = Models::User.all
      present :data, users, with: Models::User::Entity
    end


    desc 'Creates a new user',
      entity:  Models::User::Entity,
      params:  Models::User::Input.documentation_in_body,
      failure: [ { code: 422, message: 'Invalid input' } ]
    post do
      CreateUser.(params) do
        ok   { |user|   present user }
        fail { |errors| api_response errors }
      end
    end

    route_param :id do
      desc "Resets a user's password",
        params:  Models::PasswordReset::Input.documentation_in_body,
        success: { code: 204 },
        failure: [ { code: 422, message: 'Invalid input' }, { code: 401, message: 'Invalid verification code' } ]
      patch :reset_password do
        ResetPassword.(params) do
          ok   { body false }
          fail { |errors| api_response errors }
        end
      end

      desc 'Updates an existing user',
        entity:  Models::User::Entity,
        params:  Models::User::Input.documentation_in_body,
        failure: [ { code: 422, message: 'Invalid input' }, { code: 403, message: 'Unauthorized operation attempt' } ],
        headers: { 'Authorization' => { description: 'JWT Authorization Token', required: true } }
      put do
        UpdateUser.(current_user, params) do
          ok   { |user|   present user }
          fail { |errors| api_response errors }
        end
      end
    end
  end
end
