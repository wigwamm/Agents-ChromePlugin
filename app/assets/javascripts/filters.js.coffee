# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

  $('form').on 'click', '.add_fields', (event) ->
    $(this).before($(this).data('field'))
    event.preventDefault()

  $('form').on 'click', '.remove_area', (event) ->
    $(this).parent().remove()
    event.preventDefault()

  $('a.edit').click (event) ->
    coordinates = []
    latLngs = polygon._latlngs
    for latLng in latLngs
      coordinates.push [latLng.lat, latLng.lng]

    coordinates.push [latLngs[0].lat, latLngs[0].lng]

    $.post "#{window.location.pathname}/polygon", {polygon: coordinates}, (result) ->
      window.location.reload()