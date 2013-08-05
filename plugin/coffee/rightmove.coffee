SET_CURRENT_LISTING = 0
RETURN_CURRENT_LISTING = 1
FLAG_CURRENT_LISTING = 2
SEARCH_URLS = 3

sendMessage = (action, json, callback = null) ->
  chrome.runtime.sendMessage({
    action: action,
    data: json
  }, (response) ->
    unless callback is null
      callback(response)
  )

$ ->
  propertyType = $("#propertytype").text()
  address = $("#addresscontainer").text()
  thumbnail = $("#mainphoto").attr("src")

  sendMessage(SET_CURRENT_LISTING,
    {
      type: propertyType,
      address: address,
      thumbnail: thumbnail,
      url: window.location.href
    }
  )

  urls = []
  links = $('.address.bedrooms a')
  links.each((i, el) ->
    urls.push window.location.origin + $(el).attr('href')
  )

  # Unknown page
  if urls.length is 0 then return

  sendMessage(SEARCH_URLS, urls, (listings) ->
    # Loop through listings and mark unavailable ones
    for listing in listings
      # Every listing may have multiple URLs
      for url in listing.urls

        links.each (i, el) ->
          # Match the full url (a tags have partials)
          linkUrl = window.location.origin + $(el).attr('href')
          if linkUrl is url
            $(el).parents('li').css({'background-color': 'red'})

  )