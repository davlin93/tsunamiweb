class Api::RippleController < ApplicationController
  def index
    @ripples = Ripple.all

    response = []
    @ripples.each do |ripple|
      json = {
          id: ripple.id,
          latitude: ripple.latitude,
          longitude: ripple.longitude,
          radius: ripple.radius,
          created_at: ripple.created_at,
          updated_at: ripple.updated_at,
          user: ripple.user,
          wave: ripple.wave
        }
      response << json
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  def create
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    @wave = Wave.find(params[:wave_id])
    @ripple.wave = @wave

    @user = User.find(params[:user_id])

    @user.viewed += 1
    @user.save
    @user.ripples << @ripple

    @wave.views += 1
    @wave.save

    if @ripple.save
      response = {
        id: @ripple.id,
        latitude: @ripple.latitude,
        longitude: @ripple.longitude,
        radius: @ripple.radius,
        created_at: @ripple.created_at,
        updated_at: @ripple.updated_at,
        user: @ripple.user,
        wave: @ripple.wave
      }
      render json: response, status: :created
    else
      render json: @ripple.errors, status: :unprocessable_entity
    end
  end
end
