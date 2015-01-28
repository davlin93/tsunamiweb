require 'rails_helper'

describe Api::UsersController do
  describe 'GET #index' do
    it 'returns users' do
      @user = FactoryGirl.create(:user)
      get :index, {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.first["id"]).to eq(@user.id)
    end
  end

  describe 'POST #create' do
    it 'creates a user' do
      user = FactoryGirl.build(:user)
      post :create, { guid: user.guid }, { "Content-Type" => "application/json" }
      expect(response.code).to eq('201')
      expect(User.last.id).to eq(JSON.parse(response.body)['id'])
    end
  end
end