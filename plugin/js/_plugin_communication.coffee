sendMessage = (action, json, callback = null) ->
  requestStartTime = new Date().getTime()
  $('.plugin-loading-bar').fadeIn()

  chrome.runtime.sendMessage({
    action: action,
    data: {userId: userId, data:json}
  }, (response) ->

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