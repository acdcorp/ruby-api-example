class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        if token = headers['Authorization']
          @current_user = Models::User.with_pk(extract_user_id(token))
          Api.logger.info("Authorized as '#{current_user.email}'")
        end
      rescue JWT::DecodeError
        error!({error_type: :unauthorized}, :unauthorized)
      end

      def current_user
        @current_user
      end

      def extract_user_id(token)
        JWT.decode(token, HMAC_SECRET, true, algorithm: 'HS256')[0]['user_id']
      end

      def auth_token_for(user)
        payload = {
          iss:     "ruby-api-example",
          exp:     Time.now.to_i + 4 * 1.hour,
          user_id: user.id
        }

        JWT.encode(payload, HMAC_SECRET, 'HS256')
      end
    end
  end
end
