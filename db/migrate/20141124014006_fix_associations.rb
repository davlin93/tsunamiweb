class FixAssociations < ActiveRecord::Migration
  def change
    add_column :waves, :user_id, :integer
    add_index :waves, :user_id
  end
end
