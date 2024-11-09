# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

authors = 10.times.map do
  Author.create!(name: Faker::Book.author)
end

genres = 5.times.map do
  Genre.create!(name: Faker::Book.genre)
end

20.times do
  Book.create!(
    title: Faker::Book.title,
    author: authors.sample,
    genre: genres.sample,
    isbn: Faker::Number.unique.number(digits: 13).to_s,
    total_copies: Faker::Number.between(from: 5, to: 20),
    available_copies: Faker::Number.between(from: 1, to: 5)
  )
end
