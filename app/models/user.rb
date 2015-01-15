class User < ActiveRecord::Base
  attr_accessible :expires_at, :image, :name, :provider, :token, :uid, :guid,
    :viewed

  has_many :ripples
  has_many :waves
  has_many :comments

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

  def self.process_guid(guid)
    user = User.find_by_guid(guid)

    if user.nil?
      User.create(guid: guid)
    else
      user
    end
  end
end
