class BookSerializer
  include JSONAPI::Serializer

  attributes :title, :total_copies, :available_copies

  has_many :transactions
end
