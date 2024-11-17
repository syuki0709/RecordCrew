class Studio < ApplicationRecord
  # アソシエーション
  has_many :reservations
  has_many :studio_availabilities

  # バリデーション
  validates :name, presence: true
  validates :hourly_rate, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/, message: "は有効な電話番号を入力してください" }
end
