class AddViewedToUser < ActiveRecord::Migration
  def change
    add_column :users, :viewed, :integer, default: 0
  end
end
