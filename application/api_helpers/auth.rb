class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        token = env["X-Auth-Token"]
        unauthorize! unless token.present?

        @current_user = Api::Models::User.find(token: token)
        unauthorized! unless @current_user.present?
      end

      def current_user
        @current_user
      end

      def unauthorized!
        error!({ error: "Unauthorized request" }, 401)
      end
    end
  end
end
