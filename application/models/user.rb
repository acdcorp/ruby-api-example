require 'lib/abilities'

class Api
  module Models
    class User < Sequel::Model(:users)
      include AbilityList::Helpers

      def before_create
        self.token = SecureRandom.hex(18)
        super
      end

      def abilities
        @abilities ||= Abilities.new(self)
      end

      def full_name
        "#{self.first_name} #{self.last_name}"
      end
    end
  end
end
