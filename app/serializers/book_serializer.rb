class BookSerializer
  include JSONAPI::Serializer

  attributes :title, :total_copies, :available_copies, :fee

  has_many :transactions
end
