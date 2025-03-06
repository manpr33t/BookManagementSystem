FactoryBot.define do
  factory :book do
    title { "Sample Book" }
    total_copies { 10 }
    available_copies { 10 }
  end
end
