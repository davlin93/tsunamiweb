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

  def waves
    @user = User.find_by_guid(params[:guid])

    if @user.nil?
      render json: { errors: "could not find user with guid #{params[:guid]}" },
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
            ripples: wave.ripples,
            user: @user
          }
        response << json
      end
      render json: response, status: :ok
    end
  end
end
