class CreateSocialProfile < ActiveRecord::Migration
  def change
    create_table :social_profiles do |t|
      t.belongs_to :user, index: true
      t.string :service
      t.string :alias
      t.timestamps
    end
  end
end
