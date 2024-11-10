# == Schema Information
#
# Table name: authors
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Author < ApplicationRecord
  include PgSearch::Model

  has_many :books
  validates :name, presence: true, uniqueness: true
  validates_uniqueness_of :name

  pg_search_scope :search_authors, against: [ :name ],
  using: {
    tsearch: { prefix: true }
  }
end
