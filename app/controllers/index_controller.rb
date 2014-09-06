class IndexController < ApplicationController
  helper UsersHelper
  def index
    handle_locations
  end
end
