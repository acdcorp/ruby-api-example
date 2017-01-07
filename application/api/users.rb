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
      result = UserValidator.new(params).validate

      if result.success?
        @user = Models::User.create(result.output)
        ConfirmNewUserJob.perform_async(@user.email)

        present @user
      else
        api_response(error_type: :invalid, errors: result.messages)
      end
    end

    route_param :id do
      before do
        @user = Models::User.with_pk!(params[:id])
      end

      desc "Resets a user's password",
        params:  Models::PasswordReset::Input.documentation_in_body,
        success: { code: 204 },
        failure: [ { code: 422, message: 'Invalid input' }, { code: 401, message: 'Invalid verification code' } ]
      patch :reset_password do
        result = ResetPasswordValidator.new(params).validate

        if !@user.valid_reset_password_code?(result.output[:verification_code])
          api_response(error_type: :unauthorized, errors: { reason: "Invalid code" })
        elsif result.failure?
          api_response(error_type: :invalid, errors: result.messages)
        else
          @user.update(password: result.output[:new_password])
          ConfirmResetPasswordJob.perform_async(@user.email)

          body false
        end
      end

      desc 'Updates an existing user',
        entity:  Models::User::Entity,
        params:  Models::User::Input.documentation_in_body,
        failure: [ { code: 422, message: 'Invalid input' }, { code: 403, message: 'Unauthorized operation attempt' } ],
        headers: { 'Authorization' => { description: 'JWT Authorization Token', required: true } }
      put do
        result = UserValidator.new(params).validate

        if current_user.nil? || current_user.cannot?(:edit, @user)
          api_response(error_type: :forbidden, errors: { reason: "Permission denied" })
        elsif result.failure?
          api_response(error_type: :invalid, errors: result.messages)
        else
          @user.update(result.output)

          present @user
        end
      end
    end
  end
end
