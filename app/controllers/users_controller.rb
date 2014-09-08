class UsersController < ApplicationController
  def get_my_location
    handle_locations true
  end
end
