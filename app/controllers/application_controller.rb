class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  ensure_security_headers
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
end
