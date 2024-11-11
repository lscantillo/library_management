require 'rails_helper'

RSpec.describe BookPolicy, type: :policy do
  let(:librarian_user) { build(:user, role: :librarian) }
  let(:member_user) { build(:user, role: :member) }
  let(:book) { build(:book) }

  subject { described_class }

  describe "#create?" do
    it "grants access to librarians" do
      policy = BookPolicy.new(librarian_user, book)
      expect(policy.create?).to be(true)
    end

    it "denies access to members" do
      policy = BookPolicy.new(member_user, book)
      expect(policy.create?).to be(false)
    end
  end

  describe "#update?" do
    it "grants access to librarians" do
      policy = BookPolicy.new(librarian_user, book)
      expect(policy.update?).to be(true)
    end

    it "denies access to members" do
      policy = BookPolicy.new(member_user, book)
      expect(policy.update?).to be(false)
    end
  end

  describe "#destroy?" do
    it "grants access to librarians" do
      policy = BookPolicy.new(librarian_user, book)
      expect(policy.destroy?).to be(true)
    end

    it "denies access to members" do
      policy = BookPolicy.new(member_user, book)
      expect(policy.destroy?).to be(false)
    end
  end
end
