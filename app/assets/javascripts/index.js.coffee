# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
namespace = (name) ->
  window[name] = window[name] or {}

class @MarkerManager
  constructor: (@mapId, @markers) ->
    @innerMarkers = []
    @handler = Gmaps.build('Google')
    @map = null;

  buildMap: (buildOptions)->
    buildOptions = {} if !buildOptions
    if !@map
      @map = @handler.buildMap {provider: {}, internal: {id: @mapId}}, =>
        @showMarkers()
        markerManager.openFirstInfoWindow()
        buildOptions.onBuilt(@map) if buildOptions.onBuilt
    else
      @showMarkers()
      markerManager.openFirstInfoWindow()

  clearMarkers: ->
    @handler.removeMarkers(@innerMarkers)

  updateMap: ->
    @buildMap()
    @

  setMarkers: (markers)->
    @markers = markers
    @

  showMarkers: ->
    if(@markers.length)
      @clearMarkers()

      @innerMarkers = @handler.addMarkers(@markers)
      marker = @innerMarkers[0]

      @handler.bounds.extendWith(@innerMarkers)
      @handler.getMap().setZoom(18)
      @handler.getMap().setCenter(marker.getServiceObject().getPosition())

  openFirstInfoWindow: ->
    if(!@markers.length)
      return;

    marker = @innerMarkers[0]
    google.maps.event.trigger(marker.getServiceObject(), 'click')


intervalLocationUpdate = null
markerManager = null

@autolocationUpdate= (markers)->
  markerManager = new MarkerManager('basic_map', markers);
  markerManager.buildMap onBuilt: (map)=>
    setTimeout ()->
      intervalLocationUpdate = setInterval ->
        locationUpdate markerManager
        , 10000
      ,10000


locationUpdate=(markerManager)->
  req = $.ajax(
    type: 'get',
    dataType: 'json',
    url: '/users/get_my_location'
  )

  req.done (data, textStatus, jqXHR) -> markerManager.setMarkers(data).updateMap()

  req.fail (jqXHR, textStatus, errorThrown) -> console.log(textStatus)

readFunc = ->
  if(intervalLocationUpdate)
    clearInterval(intervalLocationUpdate)

loadFunc = ->
  autolocationUpdate($('#location-hash').data('hash'))


onPageReady loadFunc, readFunc, false