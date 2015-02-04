class SocialProfile < ActiveRecord::Base
  attr_accessible :id, :service, :username, :user, :clicks

  belongs_to :user

end
