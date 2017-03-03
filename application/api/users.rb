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

  end
end
