class RemoveExtraUserFields < ActiveRecord::Migration
  def change
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :name
    remove_column :users, :image
    remove_column :users, :token
    remove_column :users, :expires_at
    remove_column :users, :guid
  end
end
