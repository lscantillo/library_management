# == Schema Information
#
# Table name: borrowings
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  book_id     :bigint           not null
#  borrowed_at :datetime
#  due_date    :datetime
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  context 'valid factory' do
    it { expect(FactoryBot.build(:borrowing)).to be_valid }
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'Validations' do
    subject { FactoryBot.create(:borrowing) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:book) }
    it { should validate_presence_of(:borrowed_at) }
    it { should validate_presence_of(:due_date) }
  end
end
