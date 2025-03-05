class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :book

  #associations
  validates :transaction_type, presence: true, inclusion: { in: %w[borrow] }
  validates :amount, presence: true, numericality: true

  #scopes for getting borrowed/returned/active borrowed
  scope :borrowed, ->{ where(transaction_type: 'borrow')}
  scope :returned, ->{ where(returned: true)}

  scope :active_borrowed, ->{ where(returned: false) }

  scope :for_current_month, -> {
    where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
  }

  scope :for_current_year, -> {
    where(created_at: Time.current.beginning_of_year..Time.current.end_of_year)
  }

  def mark_as_returned
    self.user.update_balance(self.amount.abs)
    update(returned: true, returned_at: Time.current)
  end
end
