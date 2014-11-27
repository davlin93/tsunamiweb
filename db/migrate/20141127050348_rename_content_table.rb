class RenameContentTable < ActiveRecord::Migration
  def change
    rename_table :content, :contents
  end
end
