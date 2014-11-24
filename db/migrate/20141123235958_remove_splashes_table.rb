class RemoveSplashesTable < ActiveRecord::Migration
  def change
    drop_table :splashes
  end
end
