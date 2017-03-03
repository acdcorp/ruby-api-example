FactoryGirl.define do
  factory :user, class: Api::Models::User do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password 'test'
    date_of_birth Date.new(2000, 1, 1)
  end
end
