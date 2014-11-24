class Ripple < ActiveRecord::Base
  RADIUS = 0.025

  attr_accessible :id, :latitude, :longitude, :radius, :status

  belongs_to :wave
  belongs_to :user
end
