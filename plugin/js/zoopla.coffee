# @include _plugin_communication
# @include _constants
# @include _common
# @include _zoopla_ui

createUserIfNecessary()

$ ->
  injectBarUI()

  # Detect which type of page the user is looking at
  if $('ul.listing-results li').length > 0
    injectSummaryListUI()
    updateAvailability()
  else if $('#listing-details').length > 0
    injectListingUI()
    updateAvailability()