module API
  module Entities
    class User < Grape::Entity
      expose :first_name
      expose :last_name
      expose :full_name
      expose :born_on
    end
  end
end