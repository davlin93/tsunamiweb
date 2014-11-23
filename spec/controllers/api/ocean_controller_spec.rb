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

    it 'returns waves with splashes within range' do
      @user = FactoryGirl.create(:user)

      # in range
      in_range = []
      @splash = FactoryGirl.create(:splash, latitude: 10.000, longitude: 10.000, user: @user)
      @wave = FactoryGirl.create(:wave, splash: @splash)
      @splash1 = FactoryGirl.create(:splash, latitude: 9.500, longitude: 9.500, user: @user)
      @wave1 = FactoryGirl.create(:wave, splash: @splash1)
      in_range << @wave.id << @wave1.id

      # out of range
      @splash2 = FactoryGirl.create(:splash, latitude: 8.999, longitude: 10.000, user: @user)
      @wave2 = FactoryGirl.create(:wave, splash: @splash2)
      @splash3 = FactoryGirl.create(:splash, latitude: 9.250, longitude: 9.250, user: @user)
      @wave3 = FactoryGirl.create(:wave, splash: @splash3)

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
end