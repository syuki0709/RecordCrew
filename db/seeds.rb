# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
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