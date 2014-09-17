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
        buildOptions.onBuilt(@map) if buildOptions.onBuilt
    else
      @showMarkers()

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
      @handler.bounds.extendWith(@innerMarkers)
      @handler.fitMapToBounds()
      #@map.centerOn([@markers[0].lat, @markers[0].lng])

@autolocationUpdate= (markers)->
  mm = new MarkerManager('basic_map', markers);
  mm.buildMap onBuilt: (map)=>
    setTimeout ()->
      setInterval ->
        locationUpdate mm
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

$ ->
  console.log $('#location-hash').data('hash')
  autolocationUpdate($('#location-hash').data('hash'))