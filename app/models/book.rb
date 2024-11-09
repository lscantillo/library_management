# == Schema Information
#
# Table name: books
#
#  id               :bigint           not null, primary key
#  title            :string
#  isbn             :string
#  total_copies     :integer
#  available_copies :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  author_id        :bigint
#  genre_id         :bigint
#
class Book < ApplicationRecord
  belongs_to :author
  belongs_to :genre
  has_many :borrowings
  validates :title, :author, :genre, :isbn, :total_copies, presence: true

end
