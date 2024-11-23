class StudioAvailability < ApplicationRecord
  belongs_to :studio

  validates :day_of_week, :business_hour_start, :business_hour_end, presence: true
  validates :business_hour_start, comparison: { less_than: :business_hour_end }
end
