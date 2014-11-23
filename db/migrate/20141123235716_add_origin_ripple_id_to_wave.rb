class AddOriginRippleIdToWave < ActiveRecord::Migration
  def change
    add_column :waves, :origin_ripple_id, :integer
  end
end
