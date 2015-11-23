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
    unless params[:latitude] && params[:longitude] && params[:user_id]
      render(json: { errors: 'missing params' }) && return
    end

    wave_limit = params[:limit] ? params[:limit] : 10

    @user = User.find(params[:user_id])

    latitude = params[:latitude].to_f
    longitude = params[:longitude].to_f
    radius = Ripple::RADIUS

    wave_ids =  Wave.joins(:ripples)
                    .where("SQRT(POWER((ripples.latitude - ?), 2)
                      + POWER((ripples.longitude - ?), 2)) < ?", latitude, longitude, radius)
                    .active
                    .pluck('waves.id')

    if wave_ids.size < 10
      generate_count = 10 - wave_ids.size
      titles = Reddit.getShowerThoughts(generate_count)
      gen_waves = MockWave.generate(titles, params[:latitude], params[:longitude])
      wave_ids += gen_waves
    end

    viewed_ids =  Wave.joins('FULL JOIN view_records ON view_records.wave_id = waves.id')
                      .joins(:ripples)
                      .where("SQRT(POWER((ripples.latitude - ?), 2) + POWER((ripples.longitude - ?), 2)) < ?
                             AND (view_records.user_id = ?)", latitude, longitude, radius, @user.id)
                      .active
                      .pluck('waves.id')

    new_wave_ids = wave_ids - viewed_ids

    if new_wave_ids.empty?
      ViewRecord.where('user_id = ?', @user.id).destroy_all
      @waves =  Wave.where('waves.id IN (?)', wave_ids)
                    .active
                    .order('created_at DESC')
                    .includes(:content, :ripples, comments: [{ user: :social_profiles }])
                    .limit(wave_limit)
    else
      @waves =  Wave.where('waves.id IN (?)', new_wave_ids)
                    .active
                    .includes(:content, :ripples, comments: [{ user: :social_profiles }])
                    .limit(wave_limit)
    end

    render json: @waves
  end

  def splash
    payload = process_jwt(params[:token])
    params = payload

    unless params
      render(json: { errors: ['bad token'] }, status: :forbidden) && return
    end

    unless params[:latitude] && params[:longitude] && params[:caption] &&
      params[:user_id] && params[:type]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end
    @ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    @ripple.save

    case params[:type]
    when 'ImageContent'
      @content = ImageContent.new(link: params[:link], caption: params[:caption])
    when 'TextContent'
      @content = TextContent.new(caption: params[:caption])
    else
      render(json: { errors: "did not recognize type #{params[:type]}" }) && return
    end

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
        created_at: @wave.created_at,
        updated_at: @wave.updated_at,
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
