class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :authenticate

  def current_user
    @current_user ||= User.find_by_auth_token(session[:auth_token]) if session[:auth_token]
  end

  def authenticate
    return if params[:skip]
    redirect_to CasClient.auth_path unless current_user
  end
end
