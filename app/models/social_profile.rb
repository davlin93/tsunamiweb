class SocialProfile < ActiveRecord::Base
  attr_accessible :id, :service, :username, :user

  belongs_to :user

end
