class SessionsController < ApplicationController
  skip_before_filter :authenticate, only: [:auth]
  def new 
  end
  
  def auth
    verification_token = params[:verification_token]
    redirect_to_login_page && return unless verification_token
    puts verification_token
    cas_user = CasClient.user(verification_token)
    redirect_to_login_page && return unless cas_user
    handle_authentication_success(cas_user)
  end

  private

  def handle_authentication_success(cas_user)
    user = User.find_or_create_by(cas_user_id: cas_user['user_id']) do |record|
      record.name = cas_user['name']
    end
    user.update_attributes(auth_token: cas_user['auth_token'])
    session[:auth_token] = user.auth_token
    redirect_to root_path
  end

  def redirect_to_login_page
    redirect_to new_session_path(skip: true)
  end
end
