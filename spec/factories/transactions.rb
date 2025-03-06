FactoryBot.define do
  factory :transaction do
    user
    book
    transaction_type { 'borrow' }
    amount { -10.0 } # Fee for borrowing
    created_at { Time.current }
  end
end
