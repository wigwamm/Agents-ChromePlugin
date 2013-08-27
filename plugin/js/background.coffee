# @include _constants

currentListing = null

#API_URL = "http://localhost:3000"
API_URL = "http://chromeplugin.herokuapp.com"

flagCurrentListing = ->

  if currentListing is null
    return

  $.post(API_URL + '/listings', currentListing, (response) ->
    console.log "Success", response
  , (error) ->
    console.log "Error", error
  )

unavailableListings = []

searchUrls = (urls, callback) ->

  $.ajax(API_URL + '/listings/search.json', {
    type: 'post',
    dataType: 'json',
    data: {urls: urls},
    success: (response) ->
      console.log "Success", response
      callback(response)
    , error: (error) ->
      console.log "Error", error
      callback([])
  })

searchListingIds = (listingIds, callback) ->
  $.ajax(API_URL + '/listings/search.json', {
    type: 'post',
    dataType: 'json',
    data: {listing_ids: listingIds},
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })

setListingUnavailable = (listingId, callback) ->
  $.ajax(API_URL + '/listings/create_id.json', {
    type: 'post',
    dataType: 'json',
    data: {id: listingId},
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })

setListingAvailable = (listingId, callback) ->
  $.ajax(API_URL + '/listings/delete_id.json', {
    type: 'delete',
    dataType: 'json',
    data: {id: listingId},
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })

onMessage = (request, sender, sendResponse) ->

  switch request.action

    when SET_CURRENT_LISTING
      currentListing = request.data
      console.log request.data

    when RETURN_CURRENT_LISTING then sendResponse currentListing

    when FLAG_CURRENT_LISTING then flagCurrentListing()

    when SEARCH_URLS then searchUrls(request.data, (listings) ->
      sendResponse listings
    )

    when SEARCH_LISTING_IDS then searchListingIds(request.data, (listings) ->
      sendResponse(listings)
    )

    when SET_LISTING_UNAVAILABLE then setListingUnavailable(request.data, (listing) ->
      sendResponse()
    )

    when SET_LISTING_AVAILABLE then setListingAvailable(request.data, (listing) ->
      sendResponse()
    )

    else
      console.log "Unknown message"

  true

chrome.runtime.onMessage.addListener(onMessage)