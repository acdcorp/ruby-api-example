require 'lib/abilities'

class Api
  module Models
    class User < Sequel::Model(:users)
      plugin :secure_password, include_validations: false

      include AbilityList::Helpers

      def abilities
        @abilities ||= Abilities.new(self)
      end

      def full_name
        "#{self.first_name} #{self.last_name}"
      end

      def update_reset_password_code!
        SecureRandom.hex(5).upcase.tap do |code|
          update(reset_password: code, reset_password_expiration: Time.now + 30.minutes)
        end
      end

      def valid_reset_password_code?(code)
        reset_password && code == reset_password && Time.now <= reset_password_expiration
      end
    end
  end
end
