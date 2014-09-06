module UsersHelper
  def handle_locations(skip_same_location = false)
    @location_hash = {}
    if signed_in? && current_user.not_expired_token?('facebook') then
      last_locations = get_last_location
      if(last_locations.size) then
        location = last_locations[0]['place']['location']

        if(!skip_same_location || !is_same_location?(location))
          @location_hash = handle_user_location(location) + handle_nearby_location(location)
          current_user.update_attributes(lat: location['latitude'].to_f, lon: location['longitude'].to_f)
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @location_hash}
    end
  end

  private

  def handle_user_location(location)
    location_hash = Gmaps4rails.build_markers([current_user]) do |user, marker|
      marker.title user.name
      marker.lat location['latitude']
      marker.lng location['longitude']
      marker.infowindow render_to_string(:partial => "/users/parts/infowindow", :locals => { user: user})
    end

    location_hash
  end

  def handle_nearby_location location
    places = get_nearby_places location

    location_hash = Gmaps4rails.build_markers(places) do |place, marker|
      # marker.title user.name
      marker.lat place['location']['latitude']
      marker.lng place['location']['longitude']
      # marker.infowindow render_to_string(:partial => "/users/parts/infowindow", :locals => { user: user})
    end

    location_hash
  end

  def graph
    @graph = Koala::Facebook::API.new(auth_token('facebook')) if @graph.nil?
    @graph
  end

  def get_last_location
    graph.get_connections("me", "tagged_places", limit: 1)
  end

  def get_nearby_places(location)
    graph.search('', type: 'place',
                    center: location['latitude'].to_s + ',' +location['longitude'].to_s, distance: 1000, limit: 50)
  end

  def is_same_location?(location)
    return false if current_user.lat.nil? || current_user.lon.nil?

    user_location_hash = Digest::MD5.digest(current_user.lat.to_s + ' ' + current_user.lon.to_s)
    new_location_hash = Digest::MD5.digest(location['latitude'].to_s + ' ' + location['longitude'].to_s)

    user_location_hash == new_location_hash
  end
end
