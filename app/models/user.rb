class User < ActiveRecord::Base
  attr_accessible :id, :viewed, :updated_at, :created_at, :guid

  has_many :ripples
  has_many :waves
  has_many :comments
  has_many :social_profiles

  def self.omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.image = auth.info.image
      user.token = auth.credentials.token
      user.expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  def to_response(profile_id = nil)
    hash = {
      id: id,
      created_at: created_at,
      updated_at: updated_at,
      viewed: viewed
    }

    if profile_id
      hash[:social_profiles] = SocialProfile.find(profile_id)
    else
      hash[:social_profiles] = social_profiles
    end

    hash
  end
end
