class AddContentToWave < ActiveRecord::Migration
  def change
    remove_column :waves, :content
    add_column :waves, :content_id, :integer

    create_table :content do |t|
      t.string :title
      t.string :body

      t.belongs_to :wave
    end
  end
end
