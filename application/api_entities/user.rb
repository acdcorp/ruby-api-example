class Api
  module Entities
    class User < Grape::Entity

      expose :full_name
      expose :first_name
      expose :last_name
      expose :email
      expose :date_of_birth, format_with: :datetime_string

    end
  end
end
