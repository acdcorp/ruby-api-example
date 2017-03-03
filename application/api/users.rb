class Api
  resource :users do

    params do
      includes :basic_search
    end

    get do
      users = SEQUEL_DB[:users].all
      present users, with: Api::Entities::User
    end

    post do
      result = Api::Validators::CreateUser.new(params).validate
      error!({ messages: result.messages } , 422) unless result.success?

      user = Api::Models::User.new(result.output)
      user.save

      present user, with: Api::Entities::User
    end

  end
end
