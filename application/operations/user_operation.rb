class Api
  class UserOperation < Operation
    def user_for(params)
      Models::User.with_pk!(params[:id])
    end
  end
end
