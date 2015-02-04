namespace :data do
  task :normalize_ids => :environment do
    waves = Wave.all

    waves.each do |w|
      w.update_attribute(:user_id, rand(1..3))
    end

    ripples = Ripple.all

    ripples.each do |r|
      r.update_attribute(:user_id, rand(1..3))
    end

    users = User.where(id: (1..3))

    users.each do |u|
      SocialProfile.create(service: 'Tsunami', username: "User ##{u.id}", user: u)
    end
  end
end