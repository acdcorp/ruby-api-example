require 'bcrypt'
require 'lib/abilities'

class Api
  module Models
    class User < Sequel::Model(:users)
      include AbilityList::Helpers

      def abilities
        @abilities ||= Abilities.new(self)
      end

      def full_name
        "#{self.first_name} #{self.last_name}"
      end

      def password
        return if self.encrypted_password.nil?

        @password ||= BCrypt::Password.new(self.encrypted_password)
      end

      def password=(new_password)
        return if new_password.nil?

        @password = BCrypt::Password.create(new_password)
        self.encrypted_password = @password
      end
    end
  end
end
