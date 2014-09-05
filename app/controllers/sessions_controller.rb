class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env['omniauth.auth']
    auth = Authorization.find_or_create auth_hash, current_user

    unless signed_in? then
      sign_in auth.user
    end

    flash[:success] = "Welcome " + auth.user.name + " to the facebook activity"
    redirect_to back_url
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