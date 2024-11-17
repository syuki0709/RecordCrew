class AddLatitudeAndLongitudeToStudios < ActiveRecord::Migration[7.0]
  def change
    add_column :studios, :latitude, :float
    add_column :studios, :longitude, :float
  end
end
