class Api::UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users
  end

  def create
    unless params[:guid]
      render(json: { errors: 'missing paramater guid' }, status: :bad_request) && return
    end

    if User.find_by_guid(params[:guid])
      render(json: { errors: 'user already exists with that guid' }) && return
    else
      @user = User.new(guid: params[:guid])
    end

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def stats
    @user = User.find(params[:user_id])

    if @user.nil?
      render json: { errors: "could not find user with id #{params[:user_id]}" },
        status: :bad_request
    else
      viewed = @user.viewed
      ripples = @user.ripples.count

      if ripples == 0
        ripple_chance = 0.0
      elsif viewed == 0
        ripple_chance = 1.0
      else
        ripple_chance = ripples.to_f / viewed.to_f
      end

      splashes = @user.waves.count
      views_across_waves = Wave.where('user_id = ?', @user.id).sum('views')
      ripples_across_waves = Wave.where('waves.user_id = ?', @user.id).joins(:ripples).count
      response = {
          viewed: viewed,
          ripples: ripples,
          splashes: splashes,
          ripple_chance: ripple_chance.round(2),
          views_across_waves: views_across_waves,
          ripples_across_waves: ripples_across_waves
      }

      render json: response, status: :ok
    end
  end

  def waves
    @user = User.find(params[:user_id])

    if @user.nil?
      render json: { errors: "could not find user with id #{params[:user_id]}" },
        status: :bad_request
    else
      response = []
      waves = @user.waves
      waves.each do |wave|
        json = {
            created_at: wave.created_at,
            updated_at: wave.updated_at,
            id: wave.id,
            origin_ripple_id: wave.origin_ripple_id,
            views: wave.views,
            content: wave.content,
            ripples: wave.ripples
          }
        response << json
      end

      render json: response, status: :ok
    end
  end
end
