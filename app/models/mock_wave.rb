module MockWave
  def self.generate(titles, latitude, longitude)
    all_ripples = []
    wave_ids = []
    root_user = User.find(1)
    r = Random.new

    titles.each do |title|
      content = TextContent.create(caption: title)
      wave = Wave.create(content: content, user: root_user)
      current_ripple = Ripple.new(latitude: latitude, longitude: longitude, radius: Ripple::RADIUS, wave: wave)
      ripples = [ current_ripple ]
      r.rand((3..15)).times do
        # TODO: change square area to circle area
        lat = r.rand * ((current_ripple.latitude + 0.025) - (current_ripple.latitude - 0.025)) + (current_ripple.latitude - 0.025)
        long = r.rand * ((current_ripple.longitude + 0.025) - (current_ripple.longitude - 0.025)) + (current_ripple.longitude - 0.025)
        current_ripple = Ripple.new(latitude: lat, longitude: long, radius: Ripple::RADIUS, wave: wave)
        ripples << current_ripple
        all_ripples << current_ripple
      end

      wave_ids << wave.id
    end

    Ripple.transaction do
      all_ripples.each do |rip|
        rip.save
      end
    end

    return wave_ids
  end
end