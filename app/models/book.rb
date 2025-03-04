class Book < ApplicationRecord
	has_many :transactions

	def update_inventory(book_count, borrowed)
		count = borrowed? ? self.available_copies - book_count : self.available_copies + book_count
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
