class Splash < ActiveRecord::Base
  attr_accessible :id, :lat, :long

  belongs_to :wave
  belongs_to :user
end
