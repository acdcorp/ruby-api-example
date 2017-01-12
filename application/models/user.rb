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
    end
  end
end
