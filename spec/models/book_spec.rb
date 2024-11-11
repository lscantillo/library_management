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
require 'rails_helper'

RSpec.describe Book, type: :model do
  context 'valid factory' do
    it { expect(FactoryBot.build(:book)).to be_valid }
  end

  describe 'Associations' do
    it { should have_many(:borrowings) }
    it { should belong_to(:author) }
    it { should belong_to(:genre) }
  end

  describe 'Validations' do
    subject { FactoryBot.create(:book) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:total_copies) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:genre) }
  end
end
