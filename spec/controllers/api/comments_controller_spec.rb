require 'rails_helper'

describe Api::CommentsController do
  it 'POST #create' do
    wave = FactoryGirl.create(:wave)
    user = User.last
    ripple = FactoryGirl.create(:ripple, latitude: 1, longitude: 1, wave_id: wave.id, user_id: wave.user.id)
    wave.origin_ripple_id = ripple.id
    wave.social_profile_id = user.social_profiles.first.id
    wave.save
    post :create, { user_id: user, wave_id: Wave.last, body: 'sick comment', social_profile_id: user.social_profiles.first.id }, { "Content-Type" => "application/json" }
    expect(response.code).to eq('201')
    expect(Comment.last.body).to eq('sick comment')
  end
end
