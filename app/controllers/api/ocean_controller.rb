class Api::OceanController < ApplicationController
  def all_waves
    @waves = Wave.all

    response = []
    @waves.each do |wave|
      json = { 
          id: wave.id,
          created_at: wave.created_at,
          updated_at: wave.updated_at,
          origin_ripple_id: wave.origin_ripple_id,
          views: wave.views,
          content: wave.content,
          ripples: wave.ripples,
          user: wave.user
        }
      response << json
    end

    render json: response
  end

  def local_waves
    @user = User.find_by_guid(params[:guid])

    if @user.nil?
      @user = User.new(guid: params[:guid])
      @user.save
    end

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS
    @ripples = Ripple.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ? AND (status = 'active')", latitude, longitude, radius).all
    @ripples.delete_if do |ripple|
      # this should be a resque worker or something to auto update
      # updating these here seems very bad, temporary for small scale
      if ripple.created_at < 2.days.ago
        ripple.status = 'inactive'
        ripple.save
        true
      end
    end

    puts "ripples: #{@ripples}"
    if @ripples.empty?
      @waves = []
    else
      puts @ripples.map(&:wave_id)
      @waves = Wave.limit(10).find(@ripples.map(&:wave_id))
    end

    response = []
    wave_ids = []
    @waves.each do |wave|
      json = { 
          id: wave.id,
          created_at: wave.created_at,
          updated_at: wave.updated_at,
          origin_ripple_id: wave.origin_ripple_id,
          views: wave.views,
          content: wave.content,
          ripples: wave.ripples,
          user: wave.user
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
    puts "user: #{u}"
    if u.nil?
      @user = User.new(guid: params[:guid])
      @user.save
      puts "guid: #{@user.guid} id: #{@user.id}"
    else
      @user = u
      puts "user existed, #{@user.guid}"
    end
    @wave.save
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

  def dismiss
    unless params[:wave_id] && params[:guid]
      render(json: { errors: "missing params. Received: #{params}" }, status: :bad_request) && return
    end

    @user = User.find_by_guid(params[:guid])

    if @user.nil?
      @user = User.new(guid: params[:guid])
    end

    @wave = Wave.find_by_id(params[:wave_id])

    if @wave.nil?
      render(json: { errors: "Could not find wave with id #{params[:wave_id]}" }, status: :bad_request) && return
    end

    @wave.views += 1
    @user.viewed += 1
    ViewRecord.create(user_id: @user.id, wave_id: @wave.id)

    if @wave.save && @user.save
      render json: { }, status: :ok
    else
      render json: @wave.errors.messages, status: :unprocessable_entity
    end
  end
end
