class UsersController < ApplicationController
  helper UsersHelper
  def get_my_location
    handle_locations true
  end
end
