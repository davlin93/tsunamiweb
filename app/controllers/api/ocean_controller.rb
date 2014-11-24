class Api::OceanController < ApplicationController
  def all_waves
    @waves = Wave.all

    render json: @waves
  end

  def local_waves
    @user = User.find_by_guid(params[:guid])
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS
    @ripples = Ripple.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ?", latitude, longitude, radius)
    @splashes = Splash.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ?", latitude, longitude, radius)
    @waves = Wave.find(@ripples.map {|r| r.wave_id})
    @waves += Wave.find(@splashes.map {|s| s.wave_id})

    response = []
    @waves.each do |wave|
      json = { 
          id: wave.id,
          content: wave.content,
          splash: wave.splash,
          ripples: wave.ripples
        }
      response << json
    end

    render json: response
  end
end