class DashboardController < ApplicationController
  def index

    render locals: { title: 1 }
  end

  def generate
    puts params
    r = Random.new
    if params[:latitude].present? && params[:longitude].present?
      ripple = Ripple.new(latitude: params[:latitude], longitude: params[:longitude], radius: Ripple::RADIUS)
    else
      min_lat = 42.323
      lat_scale = 0.070
      min_long = -71.131
      long_scale = 0.088
      puts "eyy #{min_lat + (r.rand * lat_scale)}"
      ripple = Ripple.new(
        latitude: min_lat + (r.rand * lat_scale),
        longitude: min_long + (r.rand * long_scale),
        radius: Ripple::RADIUS)
    end

    ripple.save
    ripple_ids = [ripple.id]
    content = Content.new(title: params[:title], body: params[:body])
    content.save
    wave = Wave.new(content: content, origin_ripple_id: ripple.id)
    wave.save
    wave.ripples << ripple
    r.rand((3..15)).times do
      # TODO: change square area to circle area
      puts ripple.latitude
      puts ripple.longitude
      lat = r.rand * ((ripple.latitude + 0.025) - (ripple.latitude - 0.025)) + (ripple.latitude - 0.025)
      long = r.rand * ((ripple.longitude + 0.025) - (ripple.longitude - 0.025)) + (ripple.longitude - 0.025)
      ripple = Ripple.new(latitude: lat, longitude: long, radius: Ripple::RADIUS)
      ripple.save
      wave.ripples << ripple
      ripple_ids << ripple.id
    end
    puts '********'
    puts params

    render json: Ripple.list_coords(ripple_ids)
  end
end