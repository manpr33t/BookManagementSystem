FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:account_number) { |n| "ACC#{n}" }
    balance { 100 }
    password { 'password123' }
    password_confirmation { 'password123' }
    authentication_token { SecureRandom.hex(20) }
  end
end
