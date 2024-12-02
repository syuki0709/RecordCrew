# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

StudioAvailability.delete_all
Reservation.delete_all

# スタジオデータを先に作成
studio_a = Studio.find_or_create_by!(name: "スタジオA") do |studio|
  studio.address = "東京都渋谷区"
  studio.email = "studio_a@example.com"
  studio.phone_number = "03-1234-5678"
  studio.nearest_station = "渋谷駅"
  studio.hourly_rate = 3000
end

studio_b = Studio.find_or_create_by!(name: "スタジオB") do |studio|
  studio.address = "東京都新宿区"
  studio.email = "studio_b@example.com"
  studio.phone_number = "090-1234-5678"
  studio.nearest_station = "新宿駅"
  studio.hourly_rate = 5000
end

# スタジオを取得（なければエラーを出力）
studio = Studio.first
unless studio
  puts "スタジオが見つかりません。seedsファイルでStudioを先に作成してください。"
  exit
end

# 1ヶ月先までの空き日を作成
(0..30).each do |i|
  date = Date.today + i.days

  # 曜日を計算
  day_of_week = date.strftime('%A')

  # 営業開始時刻と終了時刻（タイムゾーンを明示）
  business_hour_start = Time.zone.parse('09:00')
  business_hour_end = Time.zone.parse('18:00')

  # デバッグログ（確認用）
  puts "処理中の日付: #{date}, 営業時間: #{business_hour_start} - #{business_hour_end}"

  # 空き状況をランダムに設定（固定値も検討）
  available_status = [ true, false ].sample

  # 同じ日付のデータを確認して更新または作成
  availability = studio.studio_availabilities.find_or_initialize_by(date: date)
  availability.update!(
    day_of_week: day_of_week,
    business_hour_start: business_hour_start,
    business_hour_end: business_hour_end,
    available_status: available_status
  )
end

puts "空き日データを1ヶ月分作成しました。"

# ユーザーデータの作成
user = User.find_or_create_by!(email: "user@example.com") do |u|
  u.username = "example_user"
  u.password = "password" # 必要に応じて適切なパスワードを設定
  u.password_confirmation = "password" # パスワード確認も設定
end

# 最初のスタジオに予約を作成（既存データがあれば再利用）
Reservation.find_or_create_by!(
  user: user,
  studio: studio,
  start_time: Time.now + 1.day,
  end_time: Time.now + 1.day + 2.hours,
  status: "confirmed" # 必須フィールドに値を設定（例: "confirmed"）
)
