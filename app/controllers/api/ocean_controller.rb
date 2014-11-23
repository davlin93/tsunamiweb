class Api::OceanController < ApplicationController
  def all_waves
    @waves = Wave.all

    respond_to do |format|
      format.json { render json: @waves }
    end
  end

  def local_waves
    @user = User.find_by_id(params[:user_id])
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = 1.0
    @ripples = Ripple.where("latitude BETWEEN ? AND ? AND (longitude BETWEEN ? AND ?)", latitude - radius, latitude + radius, longitude - radius, longitude + radius)
    @splashes = Splash.where("(latitude BETWEEN ? AND ?) AND (longitude BETWEEN ? AND ?)", latitude - radius, latitude + radius, longitude - radius, longitude + radius)
    @waves = Wave.find(@ripples.map {|r| r.wave_id})
    puts @waves.class
    @waves = Wave.find(@splashes.map {|s| s.wave_id})
    puts @waves.class

    puts @waves

    response = { waves: [] }
    @waves.each do |wave|
      json = { 
          id: wave.id,
          content: wave.content,
          splash: wave.splash,
          ripples: wave.ripples
        }
      response[:waves] << json
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end
end
