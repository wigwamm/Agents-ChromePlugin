# @include _constants
# @include _common

ID_PREFIX = "rightmove_"

injectBarUI = ->
  ui = $(pluginBarUI)

  $(document.body).append(ui)

injectSummaryListUI = ->
  ui = $(summaryListUI)
  injectionTarget = $('.summarymaincontent')

  injectionTarget.each (i, container) ->
    ui = ui.clone()
    container = $(container)

    # Position the UI based on the image size
    listingImg = container.find('.photos')
    ui.height(listingImg.height() + 50)
    ui.find('.plugin-unavailable').height(listingImg.height() - 8).hide()
    ui.find('a').attr('href', listingImg.find('a').attr('href'))

    # Find the property id to update states later
    id = parseInt(container.find('a').attr('id').replace(/\D/g, ''))
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

  # No results were found, don't add any extra features
  if $('#noResults').length != 0
    return

  # Detect which type of page the user is looking at
  if $('li[name="summary-list-item"]').length > 0
    injectSummaryListUI()
    updateAvailability()
  else if $('.propertydetails').length > 0
    injectListingUI()
    updateAvailability()