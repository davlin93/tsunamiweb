class Api::CommentsController < ApplicationController
  def create
    unless params[:guid] && params[:wave_id] && params[:body]
      render(json: { errors: 'missing params' }, status: :bad_request) && return
    end

    user = User.process_guid(params[:guid])

    comment = Comment.create(user_id: user.id, wave_id: params[:wave_id], body: params[:body])

    render json: {}, status: :created
  end
end