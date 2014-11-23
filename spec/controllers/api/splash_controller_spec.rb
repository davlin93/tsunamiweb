require 'rails_helper'

describe Api::SplashController do
  describe 'POST #create' do
    it 'creates a splash' do
      @user = FactoryGirl.create(:user)
      post :create, { latitude: 1.5, longitude: 0.5, content: 'test wave', guid: @user.guid }, { "Content-Type" => "application/json" }
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body["wave"]["content"]).to eq('test wave')
    end
  end
end