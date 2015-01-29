class SocialProfile < ActiveRecord::Base
  attr_accessible :id, :service, :alias

  belongs_to :user

end
