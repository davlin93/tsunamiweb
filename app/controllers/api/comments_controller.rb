class Api::CommentsController < ApplicationController
  def create
    unless params[:user_id] && params[:wave_id] && params[:body]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end

    user = User.find(params[:user_id])

    comment = Comment.create(user_id: user.id, wave_id: params[:wave_id], body: params[:body])

    render json: {}, status: :created
  end
end