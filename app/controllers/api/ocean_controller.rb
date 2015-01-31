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
    @user = User.find(params[:user_id])

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS
    @ripples = Ripple.where("SQRT(POWER((latitude - ?), 2) + POWER((longitude - ?), 2)) < ?", latitude, longitude, radius).all

    if @ripples.empty?
      @waves = []
    else
      wave_ids = @ripples.map(&:wave_id).uniq
      viewed_wave_ids = Wave.joins('FULL JOIN view_records ON view_records.wave_id = waves.id')
                            .where("waves.id IN (?) AND (view_records.user_id = ?)", wave_ids, @user.id)
                            .active
                            .pluck('waves.id')

      new_wave_ids = wave_ids - viewed_wave_ids

      if new_wave_ids.empty?
        ViewRecord.where('user_id = ?', @user.id).destroy_all
        @waves =  Wave.where('waves.id IN (?)', wave_ids)
                      .active
                      .order('created_at DESC')
                      .limit(10)
      else
        @waves =  Wave.where('waves.id IN (?)', new_wave_ids)
                      .active
                      .limit(10)
      end
    end

    response = []
    wave_ids = []
    @waves.each do |wave|
      response << wave.to_response
    end

    render json: response
  end

  def splash
    unless params[:latitude] && params[:longitude] && params[:title] && params[:body] &&
      params[:user_id] && params[:content_type] && params[:social_profile_id]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    @ripple.save
    @content = Content.new(title: params[:title], body: params[:body], content_type: params[:content_type])
    @wave = Wave.new(content: @content, origin_ripple_id: @ripple.id, social_profile_id: params[:social_profile_id])
    @wave.ripples << @ripple

    @user = User.find(params[:user_id])

    @wave.save
    @user.ripples << @ripple
    @user.waves << @wave

    if @ripple.save && @wave.save
      response = {
        id: @wave.id,
        origin_ripple_id: @wave.origin_ripple_id,
        views: @wave.views,
        content: @wave.content.to_response,
        ripples: [@ripple],
        user: @user.to_response(@wave.social_profile_id)
      }
      render json: response, status: :created
    else
      render json: @wave.errors, status: :unprocessable_entity
    end
  end

  def dismiss
    unless params[:wave_id] && params[:user_id]
      render(json: { errors: "missing params. Received: #{params}" }, status: :bad_request) && return
    end

    @user = User.find(params[:user_id])

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
