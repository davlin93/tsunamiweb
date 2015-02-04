class Comment < ActiveRecord::Base
  attr_accessible :id, :body, :user_id, :wave_id, :social_profile_id, :created_at, :updated_at

  belongs_to :user

  def serializable_hash(options)
    {
      id: id,
      created_at: created_at,
      updated_at: updated_at,
      body: body,
      user: user.to_response(social_profile_id)
    }
  end
end
