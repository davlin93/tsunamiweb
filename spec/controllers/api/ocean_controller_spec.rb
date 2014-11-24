require 'rails_helper'

describe Api::OceanController do
  describe 'GET #all_waves' do
    it 'returns all waves regardless of geo' do
      @wave = FactoryGirl.create(:wave, content: 'test wave')
      @wave1 = FactoryGirl.create(:wave, content: 'test wave 2')
      get :all_waves, {}, { "Accept" => "application/json" }
      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(2)
      expect(body[0]["id"]).to eq(@wave.id)
      expect(body[1]["id"]).to eq(@wave1.id)
    end
  end

  describe 'GET #local_waves' do
    it 'does not return waves with no splashes or ripples' do
      @user = FactoryGirl.create(:user)
      @wave = FactoryGirl.create(:wave, content: 'test wave')
      @wave1 = FactoryGirl.create(:wave, content: 'test wave 2')
      get :local_waves, { latitude: 10.0, longitude: 10.0, guid: @user.guid }, { "Accept" => "application/json" }
      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(0)
    end

    it 'returns waves with ripples within range' do
      @user = FactoryGirl.create(:user)

      # in range
      in_range = []
      @ripple = FactoryGirl.create(:ripple, latitude: 10.000, longitude: 10.000, user: @user)
      @wave = FactoryGirl.create(:wave)
      @wave.ripples << @ripple
      @ripple1 = FactoryGirl.create(:ripple, latitude: 10.0 - (Ripple::RADIUS / 2),
        longitude: 10.0 - (Ripple::RADIUS / 2), user: @user)
      @wave1 = FactoryGirl.create(:wave)
      @wave1.ripples << @ripple1
      in_range << @wave.id << @wave1.id

      # out of range
      @ripple2 = FactoryGirl.create(:ripple,
        latitude: 10.0 - (Ripple::RADIUS + 0.001), longitude: 10.000, user: @user)
      @wave2 = FactoryGirl.create(:wave)
      @wave2.ripples << @ripple2
      @ripple3 = FactoryGirl.create(:ripple, latitude: 10.0 - (Ripple::RADIUS * 0.75),
        longitude: 10.0 - (Ripple::RADIUS * 0.75), user: @user)
      @wave3 = FactoryGirl.create(:wave)
      @wave3.ripples << @ripple3

      get :local_waves, { latitude: 10.0, longitude: 10.0, guid: @user.guid }, { "Accept" => "application/json" }
      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(2)
      i = 0
      body.each do |wave|
        expect(in_range.include?(wave["id"])).to eq(true)
      end
    end
  end

  describe 'POST #splash' do
    it 'creates a splash' do
      @user = FactoryGirl.create(:user)
      post :splash, { latitude: 1.5, longitude: 0.5, content: 'test wave', guid: @user.guid }, { "Content-Type" => "application/json" }
      expect(response.code).to eq('201')
      body = JSON.parse(response.body)
      expect(body["content"]).to eq('test wave')
    end
  end
end