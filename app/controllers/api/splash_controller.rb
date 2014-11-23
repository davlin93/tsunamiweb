class Api::SplashController < ApplicationController
  def index
    @splashes = Splash.all

    response = []
    @splashes.each do |splash|
      json = {
          id: splash.id,
          lat: splash.lat,
          long: splash.long,
          created_at: splash.created_at,
          updated_at: splash.updated_at,
          user: splash.user,
          wave: splash.wave
        }
      response << json
    end

    respond_to do |format|
      format.json { render json: response }
    end
  end

  def create
    puts params
    @splash = Splash.new(lat: params[:lat], long: params[:long])
    @wave = Wave.new(content: params[:content])
    @user = User.find_by_id(params[:user_id])
    @wave.splash = @splash
    @splash.user = @user

    respond_to do |format|
      if @splash.save && @wave.save
        response = {:wave => @wave, :splash => @splash, user: @user}.to_json
        format.json { render json: response, status: :created }
      else
        format.json { render json: @splash.errors, status: :unprocessable_entity }
      end
    end
  end
end
