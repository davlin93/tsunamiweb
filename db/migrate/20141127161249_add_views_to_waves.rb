class AddViewsToWaves < ActiveRecord::Migration
  def change
    add_column :waves, :views, :integer, default: 0
  end
end
