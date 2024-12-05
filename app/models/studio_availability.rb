class StudioAvailability < ApplicationRecord
  belongs_to :studio

  validates :day_of_week, :business_hour_start, :business_hour_end, presence: true
  validates :business_hour_start, comparison: { less_than: :business_hour_end }

  def is_available_at?(hour)
    available && business_hour_start.hour <= hour && business_hour_end.hour > hour
  end
end
