class SocialProfile < ActiveRecord::Base
  attr_accessible :id, :service, :username

  belongs_to :user

end
