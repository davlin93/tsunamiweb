class AddStatusToRipples < ActiveRecord::Migration
  def change
    add_column :ripples, :status, :string, default: "active"
  end
end
