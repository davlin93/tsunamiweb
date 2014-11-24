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
end
