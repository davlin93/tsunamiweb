class AddCommentsToWaves < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :wave, index: true
      t.belongs_to :user, index: true
      t.string :body
      t.timestamps
    end
  end
end
