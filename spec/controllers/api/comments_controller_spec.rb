require 'rails_helper'

describe Api::CommentsController do
  it 'POST #create' do
    FactoryGirl.create(:wave)
    FactoryGirl.create(:user)
    post :create, { user_id: User.last, wave_id: Wave.last, body: 'sick comment' }, { "Content-Type" => "application/json" }
    expect(response.code).to eq('201')
    expect(Comment.last.body).to eq('sick comment')
  end
end
