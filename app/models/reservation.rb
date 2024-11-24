class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :studio

  validates :start_time, :end_time, presence: true
  validates :status, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, "は開始時刻より後に設定してください") if end_time <= start_time
  end
end
