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
        requires(:last_name, type: String, desc: "Users last name")
        requires(:first_name, type: String, desc: "Users first name")
        requires(:password, type: String, desc: "Users password")
        optional(:born_on, type: DateTime, desc: "Users birth date (YYYY-MM-DD)")
      end
    end

    post do
      user_validator = UserCreationValidator.new(params[:user])
      validation_result = user_validator.validate
      if validation_result.success?
        user = Api::Models::User.create(params[:user])
        WelcomeEmailWorker.perform_async(user.email)

        present :user, user, with: API::Entities::User
      else
        error!({ errors: validation_result.messages }, 400)
      end
    end

    params do
      group :user, type: Hash do
        optional(:email, type: String, desc: "Users email address")
        optional(:last_name, type: String, desc: "Users last name")
        optional(:first_name, type: String, desc: "Users first name")
        optional(:born_on, type: DateTime, desc: "Users birth date (YYYY-MM-DD)")
      end
    end

    desc "updates a user" do
      headers XAuthToken: {
            description: 'Valdates your identity',
            required: true
          }
    end

    put ':id' do
      authenticate!
      user = Api::Models::User.find(id: params[:id])
      unauthorized! if user.id != current_user.id

      user_validator = UserCreationValidator.new(params[:user])
      validation_result = user_validator.validate

      if validation_result.success?
        user.update(params[:user])

        present :user, user, with: API::Entities::User
      else
        error!({ errors: validation_result.messages }, 400)
      end
    end
  end
end
