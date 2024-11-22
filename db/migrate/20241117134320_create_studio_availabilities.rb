class CreateStudioAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :studio_availabilities do |t|
      t.string :day_of_week
      t.time :business_hour_start
      t.time :business_hour_end
      t.boolean :available_status
      t.references :studio, null: false, foreign_key: true

      t.timestamps
    end
  end
end
