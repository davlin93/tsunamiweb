class Wave < ActiveRecord::Base
  attr_accessible :id, :content, :origin_ripple_id, :views

  has_many :ripples
  belongs_to :user
  has_one :content
end
