class Api::Models::User
  class Entity < Grape::Entity
    format_with(:iso_timestamp) do |date|
      date.utc.iso8601 if date
    end

    expose :id, documentation: { type: "Integer", desc: "Identifier" }
    expose :first_name, documentation: { desc: "First Name", required: true }
    expose :last_name, documentation: { desc: "Last Name", required: true }
    expose :email, documentation: { desc: "Email", required: true }

    with_options(format_with: :iso_timestamp) do
      expose :born_on, documentation: { type: "dateTime", desc: "Birthdate" }
      expose :created_at, documentation: { type: "dateTime", desc: "Created at" }
      expose :updated_at, documentation: { type: "dateTime", desc: "Updated at" }
    end    
  end

  class Input < Entity
    unexpose :id, :created_at, :updated_at
    expose :password, documentation: { desc: "Password", required: true }
  end
end
