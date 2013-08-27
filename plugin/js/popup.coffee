# @include _constants

sendMessage = (action, json, callback = null) ->
  chrome.runtime.sendMessage({
    action: action,
    data: json
  }, (response) ->
    unless callback is null
      callback(response)
  )

$ ->
  address = $("#address")
  type = $("#type")
  thumbnail = $("#thumbnail")

  $("#markUnavailable").click ->
    sendMessage(FLAG_CURRENT_LISTING)

  sendMessage(RETURN_CURRENT_LISTING, null, (response) ->
    address.text(response.address)
    type.text(response.type)
    thumbnail.attr("src", response.thumbnail)
  )
