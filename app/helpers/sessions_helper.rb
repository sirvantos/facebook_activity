module SessionsHelper
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  def sign_out
    current_user.update_attribute(:remember_token, User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # current user
  def current_user=(user)
    @current_user = user
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end


  #auth token
  def auth_token=(auth_token)
    @auth_token = auth_token
  end

  def auth_token(provider)
    @auth_token ||= get_auth_token(provider)
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, :flash => { :warning => "Please sign in" }
    end
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def back_url(back_url = nil)
    if !session[:back_url].nil?
      session[:back_url]
    else
      if !back_url.nil?
        back_url
      else
        root_path
      end
    end
  end

  def back_url=(back_url)
    if back_url.nil?
      @back_url = request.original_url if request.get?
    else
      @back_url = back_url
    end

    session[:back_url] = @back_url
  end

  private
    def get_auth_token provider
      auth_token = nil
      if signed_in? && current_user.not_expired_token?(provider) then
        session_key = 'auth_pool_' + provider + '_auth_token'
        if session.has_key?(session_key) then
          auth_token = session[session_key]
        else
          auth_token = current_user.authorizations.find_by_provider(provider).auth_token
          session[session_key] = auth_token
        end
      end

      auth_token
    end
end
