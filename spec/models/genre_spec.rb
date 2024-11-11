# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  context 'valid factory' do
    it { expect(FactoryBot.build(:genre)).to be_valid }
  end

  describe 'Associations' do
    it { should have_many(:books) }
  end

  describe 'Validations' do
    subject { FactoryBot.create(:genre) }

    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
