class RenameAlias < ActiveRecord::Migration
  def change
    rename_column :social_profiles, :alias, :username
  end
end
