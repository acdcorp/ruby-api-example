Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id

      String   :first_name,      null: false
      String   :last_name,       null: false
      String   :password_digest, null: false
      String   :email,           null: false
      DateTime :born_on
      String   :reset_password 
      DateTime :reset_password_expiration

      DateTime :created_at,      null: false
      DateTime :updated_at,      null: false
    end
  end
end
