require 'rails_helper'

describe Api::UsersController do
  describe 'GET #index' do
    it 'returns users' do
      FactoryGirl.create(:user, name: 'David')
      get :index, {}, { "Accept" => "application/json" }
      body = JSON.parse(response.body)
      expect(body.first["name"]).to eq('David')
    end
  end

  describe 'POST #create' do
    it 'creates a user' do
      post :create, { name: "David" }, { "Content-Type" => "application/json" }
      expect(response.code).to eq('201')
      expect(User.first.name).to eq('David')
    end
  end
end