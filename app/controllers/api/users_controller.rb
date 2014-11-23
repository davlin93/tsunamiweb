class Api::UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def create
    @user = User.new(name: params[:name])

    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: :created }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
