class AddClicksToSocialProfile < ActiveRecord::Migration
  def change
    add_column :social_profiles, :clicks, :integer, default: 0
  end
end
