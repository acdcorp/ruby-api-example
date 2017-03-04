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
          error!({error_type: 'not_authorized'}, 401)
        end
      rescue JWT::DecodeError, JWT::VerificationError
        error!({error_type: 'not_authorized'}, 401)
      end

      def current_user
        @current_user
      end

      def generate_token_for_user(user)
        payload = { email: user.email }
        JWT.encode(payload, HMAC_SECRET)
      end
    end
  end
end
