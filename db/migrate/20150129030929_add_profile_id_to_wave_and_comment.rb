class AddProfileIdToWaveAndComment < ActiveRecord::Migration
  def change
    add_column :waves, :social_profile_id, :integer
    add_column :comments, :social_profile_id, :integer
  end
end
