class CreateStudioAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :studio_availabilities do |t|
      t.date :date, null: false
      t.string :day_of_week, null: false
      t.time :business_hour_start, null: false
      t.time :business_hour_end, null: false
      t.boolean :available_status, null: false, default: true
      t.references :studio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
