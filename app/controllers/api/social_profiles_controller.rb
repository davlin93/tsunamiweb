class Api::SocialProfilesController < ApplicationController
  def update
    profile = SocialProfile.find(params[:id])
    profile.clicks += 1
    profile.save

    render json: profile, status: :ok
  end
end