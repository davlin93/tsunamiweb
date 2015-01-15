require 'rails_helper'

describe Api::CommentsController do
  it 'POST #create' do
    FactoryGirl.create(:wave)
    post :create, { guid: 'root', wave_id: 1, body: 'sick comment' }, { "Content-Type" => "application/json" }
    expect(response.code).to eq('201')
    expect(Comment.last.body).to eq('sick comment')
  end
end
