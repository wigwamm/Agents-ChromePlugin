#API_URL = "http://localhost:3000"
API_URL = "http://chromeplugin.herokuapp.com"

searchListingIds = (data, callback) ->
  
  $.ajax(API_URL + '/listings/search.json', {
    type: 'post',
    dataType: 'json',
    data: {
      user_id: data.userId,
      listing_ids: data.data
    },
    success: (response) ->
      
      console.log "Success", response
      callback(response)
  , error: (error) ->
      
      console.log "Error", error
      callback([])
  })

setListingUnavailable = (data, callback) ->
  $.ajax(API_URL + '/listings/create_id.json', {
    type: 'post',
    dataType: 'json',
    data: {
      user_id: data.userId,
      id: data.data
    },
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })

setListingAvailable = (data, callback) ->
  $.ajax(API_URL + '/listings/delete_id.json', {
    type: 'delete',
    dataType: 'json',
    data: {
      user_id: data.userId,
      id: data.data
    },
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })

registerUser = (callback) ->
  $.ajax(API_URL + '/users.json', {
    type: 'post',
    dataType: 'json',
    contentType: 'application/json',
    success: (response) ->
      console.log "Success", response
      callback(response)
  , error: (error) ->
      console.log "Error", error
      callback([])
  })


onMessage = (request, sender, sendResponse) ->

  switch request.action

    when SEARCH_LISTING_IDS then searchListingIds(request.data, (listings) ->
      sendResponse(listings)
    )

    when SET_LISTING_UNAVAILABLE then setListingUnavailable(request.data, (listing) ->
      sendResponse()
    )

    when SET_LISTING_AVAILABLE then setListingAvailable(request.data, (listing) ->
      sendResponse()
    )

    when REGISTER_USER then registerUser((user) ->
      sendResponse(user)
    )

    else
      console.log "Unknown message"

  true