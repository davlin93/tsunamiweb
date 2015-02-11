class AddTypeToContent < ActiveRecord::Migration
  def change
    add_column :contents, :type, :string
    add_column :contents, :link, :string
    remove_column :contents, :content_type
    remove_column :contents, :body
    rename_column :contents, :title, :caption
  end
end
