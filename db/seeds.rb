# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_or_create_by!(email: "user@example.com") do |u|
    u.username = "example_user"
    u.password = "password" # 必要に応じて適切なパスワードを設定
    u.password_confirmation = "password" # パスワード確認も設定
  end

  # スタジオを作成（既存データがあれば再利用）
  Studio.find_or_create_by!(name: "スタジオA") do |studio|
    studio.address = "東京都渋谷区"
    studio.email = "studio_a@example.com"
    studio.phone_number = "03-1234-5678"
    studio.nearest_station = "渋谷駅"
    studio.hourly_rate = 3000
  end

  Studio.find_or_create_by!(name: "スタジオB") do |studio|
    studio.address = "東京都新宿区"
    studio.email = "studio_b@example.com"
    studio.phone_number = "090-1234-5678"
    studio.nearest_station = "新宿駅"
    studio.hourly_rate = 5000
  end

  # ユーザーとスタジオの予約を作成（既存データがあれば再利用）
  studio = Studio.first
  Reservation.find_or_create_by!(
    user: user,
    studio: studio,
    start_time: Time.now + 1.day,
    end_time: Time.now + 1.day + 2.hours,
    status: "confirmed" # 必須フィールドに値を設定（例: "confirmed"）
  )
