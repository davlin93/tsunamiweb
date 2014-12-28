class DashboardController < ApplicationController
  def index

    render locals: { title: 1 }
  end

  def generate
    user = User.find_by_guid('root') || User.create(guid: 'root')

    r = Random.new
    if params[:latitude].present? && params[:longitude].present?
      ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    else
      min_lat = 42.323
      lat_scale = 0.070
      min_long = -71.131
      long_scale = 0.088
      ripple = Ripple.new(
        latitude: min_lat + (r.rand * lat_scale),
        longitude: min_long + (r.rand * long_scale),
        radius: Ripple::RADIUS)
    end

    ripple.user = user
    ripple.save
    ripple_ids = [ripple.id]
    content = Content.new(title: params[:title], body: params[:body])
    content.save
    wave = Wave.new(content: content, origin_ripple_id: ripple.id)
    wave.user = user
    wave.save
    wave.ripples << ripple

    r.rand((3..15)).times do
      # TODO: change square area to circle area
      lat = r.rand * ((ripple.latitude + 0.025) - (ripple.latitude - 0.025)) + (ripple.latitude - 0.025)
      long = r.rand * ((ripple.longitude + 0.025) - (ripple.longitude - 0.025)) + (ripple.longitude - 0.025)
      ripple = Ripple.new(latitude: lat, longitude: long, radius: Ripple::RADIUS)
      ripple.save
      wave.ripples << ripple
      ripple_ids << ripple.id
    end

    render json: Ripple.list_coords(ripple_ids)
  end

  def undo
    wave = Wave.last
    wave.ripples.destroy_all
    wave.content.destroy
    wave.destroy

    render nothing: true
  end
end