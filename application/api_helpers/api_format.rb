class Api
  module ApiFormat
    extend Grape::API::Helpers

    Grape::Entity.format_with :datetime_string do |date|
      date.to_time.to_s if date
    end

  end
end
