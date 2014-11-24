class Wave < ActiveRecord::Base
  attr_accessible :id, :content, :origin_ripple_id

  has_many :ripples
  belongs_to :user
end
