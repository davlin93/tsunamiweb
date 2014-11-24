class AddRadiusScale < ActiveRecord::Migration
  def change
    change_column :ripples, :radius, :decimal, precision: 7, scale: 4
  end
end
