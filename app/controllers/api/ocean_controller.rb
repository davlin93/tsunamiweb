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
    @user = User.process_guid(params[:guid])

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS
    @ripples = Ripple.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ? AND (status = 'active')", latitude, longitude, radius).all

    @ripples.delete_if do |ripple|
      # this should be a resque worker or something to auto update
      # updating these here seems very bad, temporary for small scale
      if ripple.created_at < 2.days.ago
        ripple.status = 'inactive'
        ripple.save # n+1 query
        true
      end
    end

    if @ripples.empty?
      @waves = []
    else
      wave_ids = @ripples.map(&:wave_id).uniq
      viewed_wave_ids = Wave.joins('FULL JOIN view_records ON view_records.wave_id = waves.id')
                            .where('waves.id IN (?) AND (view_records.user_id = ?)', wave_ids, @user.id)
                            .pluck('waves.id')

      new_wave_ids = wave_ids - viewed_wave_ids

      if new_wave_ids.empty?
        ViewRecord.where('user_id = ?', @user.id).destroy_all
        @waves =  Wave.where('waves.id IN (?)', wave_ids)
                      .order('created_at DESC')
                      .limit(10)
      else
        @waves =  Wave.where('waves.id IN (?)', new_wave_ids)
                      .limit(10)
      end
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
          content: wave.content.to_response, # n+1 query
          ripples: wave.ripples, # n+1 query
          user: wave.user
        }
      response << json
    end

    render json: response
  end

  def splash
    unless params[:latitude] && params[:longitude] && params[:title] && params[:body] && params[:guid]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    @ripple.save
    @content = Content.new(title: params[:title], body: params[:body])
    @wave = Wave.new(content: @content, origin_ripple_id: @ripple.id)
    @wave.ripples << @ripple

    @user = User.process_guid(params[:guid])

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

    @user = User.process_guid(params[:guid])

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
