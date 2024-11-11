# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Author, type: :model do
  context 'valid factory' do
    it { expect(FactoryBot.build(:author)).to be_valid }
  end

  subject { FactoryBot.build(:author) }

  describe 'Associations' do
    it { should have_many(:books) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
