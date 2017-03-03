class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        token = request.env['HTTP_AUTHORIZATION']
        payload = JWT.decode(token, HMAC_SECRET)[0]
        if @current_user = ::Api::Models::User.where(email: payload['email']).first
          true
        else
          error!('Unauthorized', 401)
        end
      rescue JWT::DecodeError, JWT::VerificationError
        error!('Unauthorized', 401)
      end

      def current_user
        @current_user
      end
    end
  end
end
