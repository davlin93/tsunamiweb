class Ripple < ActiveRecord::Base
  RADIUS = 0.025

  attr_accessible :id, :latitude, :longitude, :radius

  belongs_to :wave
  belongs_to :user
end
