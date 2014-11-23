class ChangeDecimalPrecision < ActiveRecord::Migration
  def change
    change_column :ripples, :latitude, :decimal, precision: 7, scale: 4
    change_column :ripples, :longitude, :decimal, precision: 7, scale: 4
    change_column :splashes, :latitude, :decimal, precision: 7, scale: 4
    change_column :splashes, :longitude, :decimal, precision: 7, scale: 4
  end
end
