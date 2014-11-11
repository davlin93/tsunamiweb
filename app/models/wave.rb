class Wave < ActiveRecord::Base
  attr_accessible :id, :content

  has_one :splash
  has_many :ripples
end
