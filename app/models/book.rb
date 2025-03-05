class Book < ApplicationRecord
  validates :title, presence: true
  validates :total_copies, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :available_copies, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }

	has_many :transactions
  has_many :users, through: :transactions

	def update_inventory(book_count, borrowed)
		count = borrowed ? self.available_copies - book_count : self.available_copies + book_count
    self.update_columns(available_copies: count)
	end

	def remaining_copies
    available_copies
  end

  # Calculates income for a time range
  def income(start_time, end_time)
    transactions.where(
      transaction_type: 'return',
      created_at: start_time..end_time
    ).sum(:amount)
  end
end
