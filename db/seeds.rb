# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Studio.create!([
  {
    name: "スタジオA",
    address: "東京都渋谷区",
    email: "studio_a@example.com",
    phone_number: "03-1234-5678",
    nearest_station: "渋谷駅",
    hourly_rate: 3000
  },
  {
    name: "スタジオB",
    address: "東京都新宿区",
    email: "studio_b@example.com",
    phone_number: "090-1234-5678",
    nearest_station: "新宿駅",
    hourly_rate: 5000
  }
])