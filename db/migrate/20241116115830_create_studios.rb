class CreateStudios < ActiveRecord::Migration[7.0]
  def change
    create_table :studios do |t|
      t.string :name, null: false
      t.string :address
      t.string :email, null: false
      t.string :phone_number
      t.string :nearest_station, null: false
      t.integer :hourly_rate, null: false

      t.timestamps
    end
  end
end
