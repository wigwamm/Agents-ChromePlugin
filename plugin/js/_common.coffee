# Keep track of listings and their corresponding UI on this page
listings = {}
unavailableListingIds = []

twitterBoxUI = """
               <div class="plugin-box-wrapper">
                <div class="plugin-box-container">
                 <h2>Spread the word!</h2>
                 <p>By getting more people to use ***** you help improve the quality of ads</p>
                 <a href="https://twitter.com/share" class="twitter-share-button" data-url="https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo" data-text="Lorem ipsum dolor sit amet" data-via="DoesNotExistTes" data-size="large">Tweet</a>
                 <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
                 <div class='close'>X</div>
                </div>
               </div>
               """

pluginBarUI = "<div class='plugin-loading-bar'><div class='plugin-bar-wrapper'><img src='data:image/gif;base64,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'><span>Updating Listings</span></div></div>"
summaryListUI = "<div class='plugin-wrapper'><a class='plugin-unavailable'><span>Unavailable</span></a><div class='plugin-button'><span>Mark Unavailable</span></div></div>"
listingUI = "<div class='plugin-wrapper-listing'><div class='plugin-unavailable'><span>Unavailable</span></div><div class='plugin-button'><span>Mark Unavailable</span></div></div>"

updateAvailability = ->
  listingIds = []

  for listingId of listings
    listingIds.push(ID_PREFIX + listingId)

  sendMessage(SEARCH_LISTING_IDS, listingIds, (unavailableListings) ->
    for listing in unavailableListings
      for id in listing['ids']
        cleanedId = id.replace(/\D/g, '')
        if listings.hasOwnProperty(cleanedId)
          setVisiblyUnavailable(listings[cleanedId])
          unavailableListingIds.push(parseInt(cleanedId))
  )

showTwitterUIIfNecessary = ->
  if localStorage.getItem('firstFlag')
    return

  localStorage.setItem('firstFlag', true)

  ui = $(twitterBoxUI)
  ui.find('.close').click( (e) ->
    $('.plugin-box-wrapper').fadeOut( ->
      $(this).remove()
    )
  )

  ui.click( (e) ->
    e.stopPropagation()
  )

  $(document).one('click', ->
    $('.plugin-box-wrapper').fadeOut( ->
      $(this).remove()
    )
  )

  $(document.body).append(ui)

setVisiblyUnavailable = (ui) ->
  ui.find('.plugin-unavailable').fadeIn()
  ui.closest('li').animate({'opacity': 0.3})
  ui.find('.plugin-button').css('background-color', '#2c3e50')
  ui.find('.plugin-button span').fadeOut(()->
    ui.find('.plugin-button span').text('mark available').fadeIn()
  )

setVisiblyAvailable = (ui) ->
  ui.find('.plugin-unavailable').fadeOut()
  ui.closest('li').animate({'opacity': 1})
  ui.find('.plugin-button').css('background-color', '')
  ui.find('.plugin-button span').fadeOut(()->
    ui.find('.plugin-button span').text('mark unavailable').fadeIn()
  )

setUnavailable = (id, ui) ->
  sendMessage(SET_LISTING_UNAVAILABLE, ID_PREFIX + id)
  setVisiblyUnavailable(ui)
  unavailableListingIds.push(id)

setAvailable = (id, ui) ->
  sendMessage(SET_LISTING_AVAILABLE, ID_PREFIX + id)
  setVisiblyAvailable(ui)
  unavailableListingIds.splice(unavailableListingIds.indexOf(id), 1)

userId = localStorage.getItem('userId')

createUserIfNecessary = ->
  if userId == null
    sendMessage(REGISTER_USER, null, (user) ->
      localStorage.setItem('userId', user['_id'])
    )