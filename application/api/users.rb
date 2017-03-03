class Api
  resource :users do
    params do
      includes :basic_search
    end
    get do
      users = SEQUEL_DB[:users].all

      present users, with: Api::Entities::User
    end
  end
end
