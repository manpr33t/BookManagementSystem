class TransactionSerializer
  include JSONAPI::Serializer
  
  attributes :transaction_type, :amount, :created_at

  belongs_to :user
  belongs_to :book
end
