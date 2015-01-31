class Comment < ActiveRecord::Base
  attr_accessible :id, :body, :user_id, :wave_id, :social_profile_id

end
