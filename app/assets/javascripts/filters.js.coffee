# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  $('a.edit').click (event) ->
    coordinates = []
    latLngs = Map.instance.polygon._latlngs
    for latLng in latLngs
      coordinates.push [latLng.lat, latLng.lng]

    coordinates.push [latLngs[0].lat, latLngs[0].lng]

    $.post "#{window.location.pathname}/polygon", {polygon: coordinates}, (result) ->
      window.location.reload()

class Map

  @instance = null

  constructor: (location, @listings, @agents, @localAgents, @area) ->
    Map.instance = @

    @map = L.mapbox.map('map', null, {
      zoomControl: false
    })
    .addLayer(L.mapbox.tileLayer('zanfa.map-eew6jiv6', {
      detectRetina: true,
      retinaVersion: 'zanfa.map-qpz94u34'
    }))
    .setView(location, 15)
    @populateListingMarkers()
    @populateAgentMarkers()
    @drawAreaPolygon()

  markersNotByAgent: (agentId, apply) ->
    for listing in @listings
      if (listing.agent_id != agentId)
        apply(listing)

    for agent in @localAgents
      if (agent._id != agentId)
        apply(agent)

  listingsByLocation: (location) ->
    sameLocationListings = []

    for listing in @listings
      if listing.location[0] == location[0] && listing.location[1] == location[1]
        sameLocationListings.push listing

    sameLocationListings

  urlFromListing: (listing) ->
    "http://www.rightmove.co.uk/property-to-rent/property-#{listing.property_ids[0].replace(/\D/g, '')}.html"

  populateListingMarkers: ->

    popupClosure = (listing) ->
      return (e) ->
        sameLocationListings = self.listingsByLocation([listing.location[0], listing.location[1]])
        popup_html = ''

        for similarListing in sameLocationListings
          picture = similarListing.pictures[0]
          popup_html +=
            """
              <div class="popup-listing">
                <img src="#{picture}.jpg" />
                <a href='#{self.urlFromListing(similarListing)}' target='_blank'>#{similarListing.description}</a><br />
              </div>
            """
          popup = L.popup(offset: new L.Point(1, -20))
          .setLatLng([listing.location[0], listing.location[1]])
          .setContent(popup_html)
          .openOn(self.map)


    self = @
    for listing in @listings
      options = null

      if listing.availability_score > 0
        options =
          icon: self.unavailableIcon

      listing.marker = L.marker([listing.location[0], listing.location[1]], options)
      .addTo(@map)
      .on('click', popupClosure(listing))

  populateAgentMarkers: ->
    self = @
    for agent in @localAgents

      options =
        icon: self.agentIcon

      agent.marker = L.marker([agent.location[0], agent.location[1]], options)
      .addTo(@map)

  drawAreaPolygon: ->
    @polygon = L.polygon(@area).addTo(@map)

  editPolygon: (isEditable) ->
    unless @polygon
      return

    if @polygon
      @polygon.editing.enable()
    else
      @polygon.editing.disable()

  unavailableIcon: L.icon({
    iconUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-icon-unavailable.png',
    iconRetinaUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-icon-unavailable.png',
    shadowUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-shadow.png',
    shadowRetinaUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

  agentIcon: L.icon({
    iconUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-icon-agent.png',
    iconRetinaUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-icon-agent.png',
    shadowUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-shadow.png',
    shadowRetinaUrl: 'https://s3-eu-west-1.amazonaws.com/wigwamm-plugin/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
  })

window.Map = Map

