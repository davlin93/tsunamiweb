class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= session[:user_id] && User.find_by_id(session[:user_id])
  end

  def process_jwt(token)
    begin
      jwt = JWT.decode(token, "secret").first
    rescue
      return false
    end

    jwt.with_indifferent_access
  end

  helper_method :current_user
end
