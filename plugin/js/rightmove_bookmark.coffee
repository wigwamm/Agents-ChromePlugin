# @include _background_api_calls
# @include _bookmark_communication
# @include _constants
# @include _common
# @include _rightmove_ui

setTimeout(->
  createUserIfNecessary()

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

,100)