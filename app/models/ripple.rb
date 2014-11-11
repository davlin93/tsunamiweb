class Ripple < ActiveRecord::Base
  attr_accessible :id, :lat, :long, :radius

  belongs_to :wave
  belongs_to :user
end
