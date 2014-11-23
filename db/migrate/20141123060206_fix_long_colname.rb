class FixLongColname < ActiveRecord::Migration
  def change
    rename_column :ripples, :lat, :latitude
    rename_column :ripples, :long, :longitude
    rename_column :splashes, :lat, :latitude
    rename_column :splashes, :long, :longitude
  end
end
