class Api::OceanController < ApplicationController
  def all_waves
    @waves = Wave.all

    response = []
    @waves.each do |wave|
      json = { 
          id: wave.id,
          origin_ripple_id: wave.origin_ripple_id,
          views: wave.views,
          content: wave.content,
          ripples: wave.ripples,
          user: @user
        }
      response << json
    end

    render json: response
  end

  def local_waves
    @user = User.find_by_guid(params[:guid])
    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS
    @ripples = Ripple.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ? AND (status = 'active')", latitude, longitude, radius)
    @ripples.delete_if do |ripple|
      # this should be a resque worker or something to auto update
      # updating these here seems very bad, temporary for small scale
      if ripple.created_at < 2.days.ago
        ripple.status = 'inactive'
        ripple.save
        true
      end
    end

    if @ripples.empty?
      @waves = []
    else
      @waves = Wave.find(@ripples.map {|r| r.wave_id})
    end

    response = []
    @waves.each do |wave|
      wave.views += 1
      wave.save
      json = { 
          id: wave.id,
          origin_ripple_id: wave.origin_ripple_id,
          views: wave.views,
          content: wave.content,
          ripples: wave.ripples,
          user: @user
        }
      response << json
    end

    render json: response
  end

  def splash
    puts "params: #{params}"
    unless params[:latitude] && params[:longitude] && params[:title] && params[:body] && params[:guid]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    @ripple.save
    @content = Content.new(title: params[:title], body: params[:body])
    @wave = Wave.new(content: @content, origin_ripple_id: @ripple.id)
    @wave.ripples << @ripple
    u = User.find_by_guid(params[:guid])
    if u.nil?
      @user = User.new(guid: params[:guid])
      @user.save
    else
      @user = u
    end
    @user.ripples << @ripple
    @user.waves << @wave

    if @ripple.save && @wave.save
      response = {
        id: @wave.id,
        origin_ripple_id: @wave.origin_ripple_id,
        views: @wave.views,
        content: @wave.content,
        ripples: [@ripple],
        user: @user
      }
      render json: response, status: :created
    else
      render json: @wave.errors, status: :unprocessable_entity
    end
  end
end
