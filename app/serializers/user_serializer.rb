class UserSerializer
  include JSONAPI::Serializer
  
  attributes :id, :email, :account_number, :balance

end
