class AddGuidToUser < ActiveRecord::Migration
  def change
    add_column :users, :guid, :string
  end
end
