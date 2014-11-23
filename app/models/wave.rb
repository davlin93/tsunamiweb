class Wave < ActiveRecord::Base
  attr_accessible :id, :content, :origin_ripple_id

  has_one :splash
  has_many :ripples
end
