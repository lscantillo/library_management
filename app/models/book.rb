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
  include PgSearch::Model

  belongs_to :author
  belongs_to :genre
  has_many :borrowings
  validates :title, :author, :genre, :isbn, :total_copies, presence: true
  validates :title, :isbn, uniqueness: true

  pg_search_scope :search_books, against: [ :title ],
                  associated_against: {
                    author: :name,
                    genre: :name
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
  before_create :set_available_copies

  def set_available_copies
    self.available_copies = total_copies if available_copies.nil?
  end
end
