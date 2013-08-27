# @include _constants
# @include _common

injectBarUI = ->
  ui = $(pluginBarUI)

  $(document.body).append(ui)

injectSummaryListUI = ->
  ui = $(summaryListUI)
  injectionTarget = $('ul.listing-results li')

  injectionTarget.each (i, container) ->
    ui = ui.clone()
    container = $(container)

    # Position the UI based on the image size
    listingImg = container.find('.photo-hover')
    ui.width(listingImg.width())
    ui.height(listingImg.height() + 60)
    ui.css('top', 20)
    ui.find('.plugin-unavailable').height(listingImg.height()).hide()
    ui.find('a').attr('href', listingImg.find('a').attr('href'))

    # Find the property id to update states later
    id = parseInt(container.attr('id').replace(/\D/g, ''))
    listings[id] = ui

    ((id, ui) ->
      # Bind the button to mark the listing
      ui.find('.plugin-button').click (e) ->
        if (unavailableListingIds.indexOf(id) == -1)
          setUnavailable(id, ui)
        else
          setAvailable(id, ui)
    )(id, ui)

    container.prepend(ui)


injectListingUI = ->
  id = parseInt(window.location.href.replace(/\D/g, ''))

  ui = $(listingUI)
  container = $('#propertydetails')
  ui.height(container.find('#outer').height() + 54)
  ui.find('.plugin-unavailable').height(container.find('#outer').height()).hide()

  listings[id] = ui

  # Bind the button to mark the listing
  ui.find('.plugin-button').click (e) ->
    if (unavailableListingIds.indexOf(id) == -1)
      setUnavailable(id, ui)
    else
      setAvailable(id, ui)

  container.append(ui)

$ ->
  injectBarUI()

  # Detect which type of page the user is looking at
  if $('ul.listing-results li').length > 0
    injectSummaryListUI()
    updateAvailability()
  else if $('.propertydetails').length > 0
    injectListingUI()
    updateAvailability()