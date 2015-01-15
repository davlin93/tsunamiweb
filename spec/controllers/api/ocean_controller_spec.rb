require 'rails_helper'

describe Api::OceanController do
  describe 'GET #all_waves' do
    it 'returns all waves regardless of geo' do
      @wave = FactoryGirl.create(:wave)
      @wave1 = FactoryGirl.create(:wave)
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
      @wave = FactoryGirl.create(:wave)
      @wave1 = FactoryGirl.create(:wave)
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

    it 'returns only waves with active ripples in range' do
      t = Time.now
      Timecop.freeze(t)
      @user = FactoryGirl.create(:user)
      @ripple = FactoryGirl.create(:ripple,
        latitude: 1.0, longitude: 1.0, user: @user)
      @wave1 = FactoryGirl.create(:wave)
      @wave1.ripples << @ripple
      Timecop.travel(Time.now - 3.days)
      @inactive_ripple = FactoryGirl.create(:ripple,
        latitude: 1.0, longitude: 1.0, user: @user)
      @wave2 = FactoryGirl.create(:wave)
      @wave2.ripples << @inactive_ripple
      @wave1.ripples << @inactive_ripple

      Timecop.travel(t)

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: @user.guid }, { "Accept" => "application/json" }
      
      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
      expect(body.first["id"]).to eq(@wave1.id)
      expect(body.first["ripples"].length).to eq(2) # wave still holds all ripples
      Timecop.return
    end

    it 'returns only first 10 waves' do
      user = FactoryGirl.create(:user)
      15.times do
        ripple = FactoryGirl.create(:ripple, latitude: 1.0, longitude: 1.0, user: @user)
        wave = FactoryGirl.create(:wave)
        wave.ripples << ripple
      end

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(10)
    end

    it 'returns only new waves' do
      user = FactoryGirl.create(:user)
      wave = FactoryGirl.create(:wave)
      ripple = FactoryGirl.create(:ripple, latitude: 1.0, longitude: 1.0, user: user, wave: wave)

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)

      post :dismiss, { wave_id: wave.id, guid: user.guid }, { "Content-Type" => "application/json" }

      expect(response.code).to eq('200')

      new_wave = FactoryGirl.create(:wave)
      new_ripple = FactoryGirl.create(:ripple, latitude: 1.0, longitude: 1.0, user: user, wave: new_wave)

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)
    end

    it 'returns old waves again once there are no more new waves' do
      user = FactoryGirl.create(:user)
      10.times do
        wave = FactoryGirl.create(:wave)
        ripple = FactoryGirl.create(:ripple, latitude: 1.0, longitude: 1.0, user: user, wave: wave)
      end

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(10)

      Wave.all.each do |w|
        post :dismiss, { wave_id: w.id, guid: user.guid }, { "Content-Type" => "application/json" }

        expect(response.code).to eq('200')
      end

      new_wave = FactoryGirl.create(:wave)
      new_ripple = FactoryGirl.create(:ripple, latitude: 1.0, longitude: 1.0, user: user, wave: new_wave)

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(1)

      post :dismiss, { wave_id: new_wave.id, guid: user.guid }, { "Content-Type" => "application/json" }

      get :local_waves, { latitude: 1.0, longitude: 1.0, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.length).to eq(10)
      expect(body.first['id']).to eq(new_wave.id)
    end

    it 'returns comments on wave' do
      wave1 = FactoryGirl.create(:wave)
      wave2 = FactoryGirl.create(:wave)
      user = FactoryGirl.create(:user)
      FactoryGirl.create(:ripple, latitude: 1, longitude: 1, wave: wave1)
      Comment.create(user_id: user.id, wave_id: wave1.id, body: 'comment body')
      Comment.create(user_id: user.id, wave_id: wave1.id, body: 'comment2 body')
      Comment.create(user_id: user.id, wave_id: wave2.id, body: 'comment3 body')

      get :local_waves, { latitude: 1, longitude: 1, guid: user.guid }, { 'Accept' => 'application/json' }

      expect(response.code).to eq('200')
      body = JSON.parse(response.body)
      expect(body.first['comments'].length).to eq(2)
    end
  end

  describe 'POST #splash' do
    context 'creates a splash' do
      it 'with an existing user guid' do
        @user = FactoryGirl.create(:user)
        post :splash, { latitude: 1.5, longitude: 0.5, title: 'test title', body: 'test wave', content_type: 'text', guid: @user.guid }, { "Content-Type" => "application/json" }
        expect(response.code).to eq('201')
        body = JSON.parse(response.body)
        expect(body["content"]["body"]).to eq('test wave')
        expect(body["origin_ripple_id"]).to eq(body["ripples"].first["id"])
        expect(body["ripples"].first["latitude"]).to eq("1.5")
      end

      it 'without an exisiting user' do
        guid = "12345"
        post :splash, { latitude: 1.5, longitude: 0.5, title: 'test title', body: 'test wave', content_type: 'text', guid: guid }, { "Content-Type" => "application/json" }
        expect(response.code).to eq('201')
        body = JSON.parse(response.body)
        expect(body["content"]["body"]).to eq('test wave')
        expect(body["origin_ripple_id"]).to eq(body["ripples"].first["id"])
        expect(body["ripples"].first["latitude"]).to eq("1.5")
        expect(User.find_by_guid(guid)).to_not eq(nil)
      end

      it 'with an image_link content_type' do
        post :splash, { latitude: 1.5, longitude: 0.5, title: 'test title', body: 'test wave', content_type: 'image_link', guid: 'root' }, { "Content-Type" => "application/json" }
        expect(response.code).to eq('201')
        body = JSON.parse(response.body)
        expect(body["content"]["type"]).to eq('image_link')
        expect(Content.last.content_type).to eq('image_link')
      end
    end
  end

  describe 'POST #dismiss' do
    it 'increments views on a wave' do
      wave = FactoryGirl.create(:wave)
      user = FactoryGirl.create(:user)

      expect(wave.views).to eq(0)

      post :dismiss, { wave_id: wave.id, guid: user.guid }, { "Content-Type" => "application/json" }

      wave.reload && user.reload
      expect(response.code).to eq('200')
      expect(user.viewed).to eq(1)
      expect(wave.views).to eq(1)
    end
  end
end