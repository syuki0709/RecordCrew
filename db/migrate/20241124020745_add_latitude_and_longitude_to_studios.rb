class AddLatitudeAndLongitudeToStudios < ActiveRecord::Migration[7.2]
  def change
    add_column :studios, :latitude, :float
    add_column :studios, :longitude, :float
  end
end
