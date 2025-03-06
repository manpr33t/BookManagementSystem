require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is not valid with a duplicate email" do
      create(:user, email: user.email)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it "is not valid without an account number" do
      user.account_number = nil
      expect(user).not_to be_valid
      expect(user.errors[:account_number]).to include("can't be blank")
    end

    it "is not valid with a duplicate account number" do
      create(:user, account_number: user.account_number)
      expect(user).not_to be_valid
      expect(user.errors[:account_number]).to include("has already been taken")
    end

    it "is not valid without a balance" do
      user.balance = nil
      expect(user).not_to be_valid
      expect(user.errors[:balance]).to include("can't be blank")
    end

    it "is not valid with a negative balance" do
      user.balance = -10
      expect(user).not_to be_valid
      expect(user.errors[:balance]).to include("must be greater than or equal to 0")
    end
  end

  describe "associations" do
    it "has many transactions" do
      user = create(:user)
      transaction = create(:transaction, user: user)
      expect(user.transactions).to include(transaction)
    end

    it "has many books through transactions" do
      user = create(:user)
      book = create(:book)
      create(:transaction, user: user, book: book)
      expect(user.books).to include(book)
    end
  end
end
