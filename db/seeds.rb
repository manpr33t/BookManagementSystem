# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Add sample data for books
Book.destroy_all

Book.create!(
  title: "The Jungle Book",
  total_copies: 20,
  available_copies: 20,
  created_at: Time.now,
  updated_at: Time.now,
  fee: 2.0
)

Book.create!(
  title: "Another Book",
  total_copies: 15,
  available_copies: 15,
  created_at: Time.now,
  updated_at: Time.now,
  fee: 1.5
)

Book.create!(
  title: "Sample Book",
  total_copies: 15,
  available_copies: 15,
  created_at: Time.now,
  updated_at: Time.now,
  fee: 5
)

Book.create!(
  title: "Test Book",
  total_copies: 10,
  available_copies: 10,
  created_at: Time.now,
  updated_at: Time.now,
  fee: 11
)
