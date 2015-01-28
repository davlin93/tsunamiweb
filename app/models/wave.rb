class Wave < ActiveRecord::Base
  attr_accessible :id, :content, :origin_ripple_id, :views

  has_many :ripples
  belongs_to :user
  has_one :content
  has_many :comments

  scope :active, -> { where("waves.updated_at > (NOW() - INTERVAL '7 days')") }

  def to_response
    {
      id: self.id,
      created_at: self.created_at,
      updated_at: self.updated_at,
      origin_ripple_id: self.origin_ripple_id,
      views: self.views,
      content: self.content,
      ripples: self.ripples,
      comments: self.comments,
      user: Ripple.find(origin_ripple_id).user
    }.to_json
  end
end
