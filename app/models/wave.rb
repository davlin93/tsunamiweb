class Wave < ActiveRecord::Base
  attr_accessible :id, :content, :origin_ripple_id, :views,
                  :social_profile_id

  has_many :ripples
  belongs_to :user
  has_one :content
  has_many :comments

  scope :active, -> { where("waves.updated_at > (NOW() - INTERVAL '7 days')") }

  def to_response(single_social_profile = true)
    {
      id: self.id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      origin_ripple_id: self.origin_ripple_id,
      views: self.views,
      content: self.content,
      ripples: self.ripples,
      comments: self.comments,
      user: single_social_profile ? user.to_response(social_profile_id) : user.to_response
    }
  end

  def serializable_hash(options)
    {
      id: self.id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      origin_ripple_id: self.origin_ripple_id,
      views: self.views,
      content: self.content,
      ripples: self.ripples,
      comments: self.comments,
      user: user.to_response(social_profile_id)
    }
  end
end
