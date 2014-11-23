class Ripple < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude, :radius

  belongs_to :wave
  belongs_to :user
end
