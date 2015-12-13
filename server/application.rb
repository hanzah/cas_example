require 'json'
require 'sinatra/base'
require './config/environment'

class CASServer < Sinatra::Base
  configure do
    enable :sessions
  end
  
  before do
    @client = Client.authorize(params[:client_id], params[:client_secret])
    halt(401, {'Content-Type' => 'application/json'}, 'Not Authorized') unless @client
  end

  def current_user
    @current_user ||= User.find_by_auth_token(session[:auth_token]) if session[:auth_token]
  end
  
  get '/auth' do
    if current_user
      redirect generate_url(@client.redirect_path, verification_token: current_user.verification_token)
    else
      redirect to(@client.redirect_path)
    end
  end
  
  post '/auth' do
    user = User.authenticate(params[:email], params[:password])
    if user
      # User is found, return varification token
      session[:auth_token] = user.auth_token
      redirect generate_url(@client.redirect_path, verification_token: user.verification_token)
    else
      # User not found, return without verification token
      redirect to(@client.redirect_path)
    end
  end

  get '/verify' do
    user = User.verify_token(params[:verification_token])
    halt 200, {'Content-Type' => 'application/json'}, user.to_json(except: [:verification_token])
  end  
end
