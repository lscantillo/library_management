FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { "password123" }

    # Define role
    trait :member do
      role { 0 }
    end

    trait :librarian do
      role { 1 }
    end
  end
end
