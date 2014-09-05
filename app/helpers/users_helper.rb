module UsersHelper
  def handle_locations
    @location_hash = {}
    if signed_in? && current_user.not_expired_token?('facebook') then
      last_locations = get_last_location
      if(last_locations.size) then
        location = last_locations[0]['place']['location']
        @location_hash = Gmaps4rails.build_markers([current_user]) do |user, marker|
          marker.title user.name
          marker.lat location['latitude']
          marker.lng location['longitude']
          marker.infowindow render_to_string(:partial => "/users/parts/infowindow", :locals => { user: user})
        end

        respond_to do |format|
          format.html # index.html.erb
          format.json { render json: @location_hash}
        end
      end
    end
  end

  private

  def get_last_location
    graph = Koala::Facebook::API.new(auth_token('facebook'))
    graph.get_connections("me", "tagged_places", limit: 1)
  end
end
