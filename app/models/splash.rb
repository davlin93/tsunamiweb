class Splash < ActiveRecord::Base
  attr_accessible :id, :latitude, :longitude

  belongs_to :wave
  belongs_to :user
end
