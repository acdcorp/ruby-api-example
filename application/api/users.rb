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

      current_user.update(result.output)
      present current_user, with: Api::Entities::User
    end

    params do
      requires :new_password, type: String
      requires :confirm_password, type: String
    end

    patch '/:id/reset_password' do
      result = Api::Validators::ResetUserPassword.new(declared(params)).validate
      error!({ errors: result.messages } , 422) unless result.success?

      if user = Api::Models::User.where(id: params[:id]).first
        user.password = result.output['new_password']
        user.save
        api_response({status: :ok})
      else
        api_response({error_type: :not_found})
      end
    end

  end
end
