class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :studio

  validates :start_time, :end_time, presence: true
  validates :status, presence: true
  validate :end_time_after_start_time
  validate :time_slot_not_taken

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, "は開始時刻より後に設定してください") if end_time <= start_time
  end

  def time_slot_not_taken
    overlapping_reservations = Reservation.where(studio: studio)
                                          .where.not(id: id) # 自分自身を除外
                                          .where('start_time < ? AND end_time > ?', end_time, start_time)

    if overlapping_reservations.exists?
      errors.add(:base, "この時間帯は既に予約されています。")
    end
  end
end
