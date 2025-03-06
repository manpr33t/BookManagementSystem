require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { build(:book) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(book).to be_valid
    end

    it "is not valid without a title" do
      book.title = nil
      expect(book).not_to be_valid
      expect(book.errors[:title]).to include("can't be blank")
    end

    it "is not valid without total_copies" do
      book.total_copies = nil
      expect(book).not_to be_valid
      expect(book.errors[:total_copies]).to include("can't be blank")
    end

    it "is not valid with negative total_copies" do
      book.total_copies = -1
      expect(book).not_to be_valid
      expect(book.errors[:total_copies]).to include("must be greater than or equal to 0")
    end

    it "is not valid without available_copies" do
      book.available_copies = nil
      expect(book).not_to be_valid
      expect(book.errors[:available_copies]).to include("can't be blank")
    end

    it "is not valid with negative available_copies" do
      book.available_copies = -1
      expect(book).not_to be_valid
      expect(book.errors[:available_copies]).to include("must be greater than or equal to 0")
    end

    it "is not valid without a fee" do
      book.fee = nil
      expect(book).not_to be_valid
      expect(book.errors[:fee]).to include("can't be blank")
    end

    it "is not valid with a negative fee" do
      book.fee = -1
      expect(book).not_to be_valid
      expect(book.errors[:fee]).to include("must be greater than or equal to 0")
    end
  end

  describe "associations" do
    it "has many transactions" do
      book = create(:book)
      transaction = create(:transaction, book: book)
      expect(book.transactions).to include(transaction)
    end

    it "has many users through transactions" do
      book = create(:book)
      user = create(:user)
      create(:transaction, book: book, user: user)
      expect(book.users).to include(user)
    end
  end
end
