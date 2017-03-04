Sequel.migration do
  change do
    rename_column :users, :password, :encrypted_password
    rename_column :users, :born_on, :date_of_birth
  end
end
