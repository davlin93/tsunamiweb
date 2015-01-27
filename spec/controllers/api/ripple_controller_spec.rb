require 'rails_helper'

describe Api::RippleController do
  describe 'POST #create' do
    it 'creates a ripple' do
      @user = FactoryGirl.create(:user)
      @wave = FactoryGirl.create(:wave)
      post :create, { latitude: 123.456, longitude: 0.5, wave_id: @wave.id, user_id: @user.id }, { "Content-Type" => "application/json" }
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body["user"]["id"]).to eq(@user.id)
      expect(body["wave"]["id"]).to eq(@wave.id)
      expect(body["latitude"]).to eq("123.456")
    end
  end
end