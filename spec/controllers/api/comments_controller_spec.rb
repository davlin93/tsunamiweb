require 'rails_helper'

describe Api::CommentsController do
  it 'POST #create' do
    wave = FactoryGirl.create(:wave)
    user = FactoryGirl.create(:user)
    ripple = FactoryGirl.create(:ripple, latitude: 1, longitude: 1, wave_id: wave.id, user_id: user.id)
    wave.origin_ripple_id = ripple.id
    wave.save
    post :create, { user_id: User.last, wave_id: Wave.last, body: 'sick comment' }, { "Content-Type" => "application/json" }
    expect(response.code).to eq('201')
    expect(Comment.last.body).to eq('sick comment')
  end
end
