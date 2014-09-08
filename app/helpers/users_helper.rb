include ApplicationHelper
module UsersHelper
  def handle_locations(skip_same_location = false)
    @location_hash = {}
    if signed_in? && current_user.not_expired_token?('facebook') then
      last_locations = get_last_location
      if(last_locations.size) then
        place = last_locations[0]['place']

        if(!skip_same_location || !is_same_location?(place))
          current_user.update_attributes(lat: place['location']['latitude'].to_f, lon: place['location']['longitude'].to_f)
          @location_hash = handle_user_location(place) + handle_nearby_location
        end
      end
    end

     respond_to do |format|
       format.html # index.html.erb
       format.json { render json: @location_hash}
     end
  end

  private

  def handle_user_location(place)
    location_hash = Gmaps4rails.build_markers([current_user]) do |user, marker|
      data_source = {
          title: user.name,
          description: get_user_place_description(user, place),
          image: {href: user.image, alt: user.name},
      }

      marker.title user.name
      marker.lat place['location']['latitude']
      marker.lng place['location']['longitude']
      marker.infowindow render_info_window(data_source)
      marker.picture({
           :url => "http://www.google.com/mapfiles/ms/micons/blue-dot.png", # up to you to pass the proper parameters in the url, I guess with a method from device
           :width   => 32,
           :height  => 32
       })
    end

    location_hash
  end

  def handle_nearby_location
    places = get_nearby_places

    render text: places.inspect
    location_hash = Gmaps4rails.build_markers(places) do |one_place, marker|
      next if is_same_location? one_place

      data_source = {
          title: one_place['name'].to_s,
          description: get_user_place_description(nil, one_place)
      }
      # marker.title user.name
      marker.lat one_place['location']['latitude']
      marker.lng one_place['location']['longitude']
      marker.infowindow render_info_window(data_source)
      marker.picture({
        :url => "http://www.google.com/mapfiles/ms/micons/red-dot.png", # up to you to pass the proper parameters in the url, I guess with a method from device
        :width   => 32,
        :height  => 32
       })
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

  def get_nearby_places
    return {} if current_user.lat.nil? || current_user.lon.nil?

    graph.search('', type: 'place', center: current_user.lat.to_s + ',' + current_user.lon.to_s, distance: 1000, limit: 50)
  end

  def is_same_location?(place)
    return false if current_user.lat.nil? || current_user.lon.nil?

    user_location_hash = Digest::MD5.digest(current_user.lat.to_s + ' ' + current_user.lon.to_s)
    new_location_hash = Digest::MD5.digest(place['location']['latitude'].to_s + ' ' + place['location']['longitude'].to_s)

    user_location_hash == new_location_hash
  end

  def get_user_place_description(user = nil, place = nil)
    descr = ''
    location = place['location']
    if user != nil
      descr = user.name
      descr += ' at ' unless place['name'].blank?
    end

    descr += place['name'] + ' ' unless place['name'].blank?
    descr += location['city'].to_s + ', ' unless location['city'].blank?
    descr += location['street'].to_s unless location['street'].blank?
    descr.strip.chomp!(',')
    descr
  end
end
