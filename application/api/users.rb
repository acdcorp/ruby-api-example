class Api
  resource :users do

    params do
      includes :basic_search
    end

    get do
      users = SEQUEL_DB[:users].all
      present users, with: Api::Entities::User
    end

    params do
      requires :first_name, type: String
      requires :last_name, type: String
      requires :email, type: String
      requires :password, type: String
      optional :date_of_birth, type: String
    end

    post do
      result = Api::Validators::CreateUser.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      user = Api::Models::User.new(result.output)
      user.save

      present user, with: Api::Entities::User
    end

    params do
      optional :first_name, type: String
      optional :last_name, type: String
      optional :email, type: String
      optional :date_of_birth, type: String
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

    params do
      requires :new_password, type: String
      requires :confirm_password, type: String
    end

    patch '/:id/reset_password' do
      result = Api::Validators::ResetUserPassword.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      unless user = Api::Models::User.where(id: params[:id]).first
        return api_response({error_type: :not_found})
      end

      user.password = result.output['new_password']
      user.save

      api_response({status: :ok})
    end

    params do
      requires :email, type: String
      requires :password, type: String
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
