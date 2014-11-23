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
    puts params
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: 1)
    @wave = Wave.find(params[:wave_id])
    @user = User.find_by_id(params[:user_id])
    @ripple.user = @user
    @ripple.wave = @wave

    respond_to do |format|
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
        format.json { render json: response, status: :created }
      else
        format.json { render json: @ripple.errors, status: :unprocessable_entity }
      end
    end
  end
end
