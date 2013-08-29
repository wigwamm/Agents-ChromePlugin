sendMessage = (action, json, callback = null) ->

  request = {
    action: action,
    data: {
      userId: localStorage.getItem('userId'),
      data: json
    }
  }

  requestStartTime = new Date().getTime()
  $('.plugin-loading-bar').fadeIn()

  onMessage(request, null, (response) ->
    if action == SET_LISTING_AVAILABLE or action == SET_LISTING_UNAVAILABLE
      showTwitterUIIfNecessary()

    requestTime = new Date().getTime() - requestStartTime
    if (requestTime >= 1000)
      $('.plugin-loading-bar').fadeOut()
    else
      setTimeout(->
        $('.plugin-loading-bar').fadeOut()
      , 1000 - requestTime)
    unless callback is null
      callback(response)
  )