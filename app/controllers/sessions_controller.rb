class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    auth = Authorization.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    unless auth then
      auth = Authorization.find_or_create auth_hash, current_user
    end

    unless signed_in? then
      sign_in auth.user
    end

    flash[:success] = "Welcome " + auth.user.name + " to the facebook activity"
    redirect_to root_url
  end

  def failure
    flash[:danger] = "Sorry, but you didn't allow access to our app!"
    render nothing: true
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end