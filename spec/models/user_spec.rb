# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  role                   :integer          default("member"), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  context 'valid factory' do
    it { expect(FactoryBot.build(:user)).to be_valid }
  end

  describe 'Associations' do
    it { should have_many(:borrowings) }
  end

  describe 'Validations' do
    subject { FactoryBot.create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:encrypted_password) }
    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end
end
