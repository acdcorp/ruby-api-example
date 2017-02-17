Sequel.migration do
  change do
    add_column :users, :token, String
  end
end
