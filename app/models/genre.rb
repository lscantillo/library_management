# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Genre < ApplicationRecord
  include PgSearch::Model

  has_many :books
  validates :name, presence: true, uniqueness: true
  validates_uniqueness_of :name

  pg_search_scope :search_genres, against: [ :name ],
                  using: {
                    tsearch: { prefix: true }
                  }
end
