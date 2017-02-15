class Api
  resource :users do
    params do
      includes :basic_search
    end
    get do
      users = SEQUEL_DB[:users].all
      {
        data: users
      }
    end

    params do
      group :user, type: Hash do
        requires(:email, type: String, desc: "Users email address")
        requires(:first_name, type: String, desc: "Users first name")
        requires(:last_name, type: String, desc: "Users last name")
        optional(:password, type: String, desc: "Users password")
        optional(:born_on, type: DateTime, desc: "Users birth date (YYYY-MM-DD)")
      end
    end

    post do
      user_validator = UserValidator.new(params[:user])

      if user_validator.validate.success?
        user = Api::Models::User.create(params[:user])

        present :user, user, with: API::Entities::User
      else
        
      end
    end
  end
end
