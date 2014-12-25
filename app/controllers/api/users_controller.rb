class Api::UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users
  end

  def create
    @user = User.new(guid: params[:guid])

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def stats
    @user = User.find_by_guid(params[:guid])

    if @user.nil?
      render json: { errors: "could not find user with guid #{params[:guid]}" },
        status: :bad_request
    else
      splashes = @user.waves.count
      ripples = @user.ripples.count
      views_across_waves = Wave.where('user_id = ?', @user.id).sum('views')
      ripples_across_waves = Wave.where('waves.user_id = ?', @user.id).joins(:ripples).count
      response = {
          splashes: splashes,
          ripples: ripples,
          views_across_waves: views_across_waves,
          ripples_across_waves: ripples_across_waves
      }

      render json: response, status: :ok
    end
  end
end
