currentListing = null

SET_CURRENT_LISTING = 0
RETURN_CURRENT_LISTING = 1
FLAG_CURRENT_LISTING = 2
SEARCH_URLS = 3

API_URL = "http://localhost:3000"
#API_URL = "http://chromeplugin.herokuapp.com"

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

    else
      console.log "Unknown message"

  true

chrome.runtime.onMessage.addListener(onMessage)