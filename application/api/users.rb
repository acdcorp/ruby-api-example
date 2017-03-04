class Api
  resource :users do

    params do
      includes :basic_search
    end

    get do
      users = SEQUEL_DB[:users].all
      present users, with: Api::Entities::User
    end

    desc "Creates a user"
    params do
      requires :first_name, type: String, desc: "User's first name"
      requires :last_name, type: String, desc: "User's last name"
      requires :email, type: String, desc: "User's email name"
      requires :password, type: String, desc: "User's password"
      optional :date_of_birth, type: String, desc: "User's date of birth / Format: YYYY:MM:DD HH:MM:SS TZ"
    end

    post do
      result = Api::Validators::CreateUser.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      user = Api::Models::User.new(result.output)
      user.save

      Api::WelcomeUserMailer.perform_async(user.id)

      present user, with: Api::Entities::User
    end

    desc "Updates a user"
    params do
      optional :first_name, type: String, desc: "User's first name"
      optional :last_name, type: String, desc: "User's last name"
      optional :email, type: String, desc: "User's email name"
      optional :date_of_birth, type: String, desc: "User's date of birth / Format: YYYY:MM:DD HH:MM:SS TZ"
    end

    put '/:id' do
      authenticate!

      result = Api::Validators::UpdateUser.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      unless user = Api::Models::User.where(id: params[:id]).first
        return api_response({error_type: :not_found})
      end

      unless current_user.can?(:edit, user)
        return api_response({error_type: :forbidden})
      end

      user.update(result.output)

      present user, with: Api::Entities::User
    end

    desc "Resets a user's password"
    params do
      requires :new_password, type: String, desc: "New password"
      requires :confirm_password, type: String, desc: "Password confirmation"
    end

    patch '/:id/reset_password' do
      result = Api::Validators::ResetUserPassword.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      unless user = Api::Models::User.where(id: params[:id]).first
        return api_response({error_type: :not_found})
      end

      user.password = result.output['new_password']
      user.save

      Api::ResetPasswordMailer.perform_async(user.id)

      api_response({status: :ok})
    end

    desc "Signin a user"
    params do
      requires :email, type: String, desc: "User's  email"
      requires :password, type: String, desc: "User's password"
    end

    post '/signin' do
      result = Api::Validators::UserSignin.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      unless user = Api::Models::User.where(email: result.output['email']).first
        return api_response({error_type: :unauthorized})
      end

      unless user.password == result.output['password']
        return api_response({error_type: :unauthorized})
      end

      token = generate_token_for_user(user)
      api_response({token: token})
    end

  end
end
