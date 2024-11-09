# == Schema Information
#
# Table name: books
#
#  id               :bigint           not null, primary key
#  title            :string
#  author           :string
#  genre            :string
#  isbn             :string
#  total_copies     :integer
#  available_copies :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Book < ApplicationRecord
  has_many :borrowings
  validates :title, :author, :genre, :isbn, :total_copies, presence: true

end
