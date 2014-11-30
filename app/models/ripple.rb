class Ripple < ActiveRecord::Base
  RADIUS = 0.025

  attr_accessible :id, :latitude, :longitude, :radius, :status

  belongs_to :wave
  belongs_to :user

  def self.list_coords(ids)
    ripples = Ripple.find(ids)
    response = []
    ripples.each do |r|
      response << { latitude: r.latitude, longitude: r.longitude }
    end
    response
  end
end
