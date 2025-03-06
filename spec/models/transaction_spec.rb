require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:transaction) { build(:transaction) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(transaction).to be_valid
    end

    it "is not valid without a transaction type" do
      transaction.transaction_type = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type][0]).to include("can't be blank")
    end

    it "is not valid with a wrong transaction type" do
      transaction.transaction_type = 'test'
      expect(transaction).not_to be_valid
      expect(transaction.errors[:transaction_type][0]).to include("is not included in the list")
    end

    it "is not valid without amount" do
      transaction.amount = nil
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount][0]).to include("can't be blank")
    end

    it "is not valid without numeric amount" do
      transaction.amount = 'abc'
      expect(transaction).not_to be_valid
      expect(transaction.errors[:amount][0]).to include("is not a number")
    end
  end

  describe 'scopes' do
    let!(:borrowed_transaction) { create(:transaction, transaction_type: 'borrow', returned: false) }
    let!(:returned_transaction) { create(:transaction, transaction_type: 'borrow', returned: true) }

    describe '.returned' do
      it 'returns transactions where returned is true' do
        expect(Transaction.returned).to include(returned_transaction)
        expect(Transaction.returned).not_to include(borrowed_transaction)
      end
    end

    describe '.active_borrowed' do
      it 'returns transactions where returned is false' do
        expect(Transaction.active_borrowed).to include(borrowed_transaction)
        expect(Transaction.active_borrowed).not_to include(returned_transaction)
      end
    end

    describe '.for_current_month' do
      let!(:current_month_transaction) { create(:transaction, created_at: Time.current) }
      let!(:last_month_transaction) { create(:transaction, created_at: 1.month.ago) }

      it 'returns transactions created in the current month' do
        expect(Transaction.for_current_month).to include(current_month_transaction)
        expect(Transaction.for_current_month).not_to include(last_month_transaction)
      end
    end

    describe '.for_current_year' do
      let!(:current_year_transaction) { create(:transaction, created_at: Time.current) }
      let!(:last_year_transaction) { create(:transaction, created_at: 1.year.ago) }

      it 'returns transactions created in the current year' do
        expect(Transaction.for_current_year).to include(current_year_transaction)
        expect(Transaction.for_current_year).not_to include(last_year_transaction)
      end
    end
  end
end
