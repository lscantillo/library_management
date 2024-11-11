FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Book #{n}" }
    isbn { Faker::Code.isbn }
    total_copies { 5 }
    available_copies { 5 }
    author
    genre
  end
end
