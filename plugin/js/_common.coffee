# Keep track of listings and their corresponding UI on this page
listings = {}
unavailableListingIds = []

twitterBoxUI = """
               <div class="plugin-box-wrapper">
                <div class="plugin-box-container">
                 <h2>Spread the word!</h2>
                 <p>By getting more people to use Wrongmove you help improve the quality of ads</p>
                 <a href="https://twitter.com/share" class="twitter-share-button" data-url="https://chrome.google.com/webstore/detail/secure-shell/pnhechapfaindjhompbnflcldabbghjo" data-text="Lorem ipsum dolor sit amet" data-via="DoesNotExistTes" data-size="large">Tweet</a>
                 <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
                 <div class='close'>X</div>
                </div>
               </div>
               """

pluginBarUI = "<div class='plugin-loading-bar'><div class='plugin-bar-wrapper'><img src='data:image/gif;base64,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'><span>Updating Listings</span></div></div>"

summaryListUI = """<div class='plugin-wrapper'>
                    <a class='plugin-unavailable'>


                    <svg>
                    <g>
                    <g>
                    <path d="M52.89,18.903L48.404,2.343c-0.457-1.686-2.208-2.686-3.912-2.234L2.368,11.273c-1.704,0.452-2.715,2.184-2.258,3.869
                    l4.486,16.562c0.457,1.685,2.208,2.685,3.912,2.233l42.125-11.165C52.335,22.32,53.347,20.589,52.89,18.903z M50.163,21.042
                    L8.039,32.208c-0.737,0.195-1.496-0.239-1.694-0.968L1.859,14.679C1.662,13.95,2.1,13.199,2.837,13.004L44.961,1.839
                    c0.737-0.195,1.496,0.238,1.693,0.967l4.486,16.562C51.338,20.096,50.9,20.847,50.163,21.042z M12.135,19.831l0.514,1.896
                    l1.641-0.435l0.386,1.424c-0.292,0.152-0.621,0.278-0.99,0.376c-0.675,0.179-1.252,0.093-1.731-0.258s-0.833-0.951-1.064-1.801
                    c-0.234-0.867-0.217-1.586,0.053-2.157c0.27-0.571,0.767-0.952,1.492-1.145c0.792-0.21,1.562-0.241,2.313-0.094l0.264-2.136
                    c-0.426-0.064-0.911-0.083-1.454-0.055s-1.103,0.119-1.682,0.272c-1.525,0.404-2.601,1.127-3.227,2.168s-0.74,2.296-0.342,3.763
                    c0.407,1.505,1.108,2.562,2.102,3.169c0.993,0.607,2.198,0.724,3.615,0.348c1.291-0.342,2.425-0.838,3.404-1.489l-1.327-4.899
                    L12.135,19.831z M33.753,10.062l1.114,4.11c0.15,0.555,0.379,1.283,0.686,2.184l-0.037,0.01l-5.056-5.431l-3.244,0.859
                    l2.463,9.092l2.2-0.584l-1.11-4.098c-0.144-0.53-0.393-1.289-0.745-2.274l0.057-0.016l5.092,5.515l3.256-0.863l-2.462-9.091
                    L33.753,10.062z M42.356,15.38l-0.465-1.717l2.754-0.729l-0.534-1.971l-2.753,0.729l-0.387-1.43l2.974-0.789l-0.534-1.971
                    l-5.458,1.446l2.463,9.091l5.457-1.446l-0.542-2.002L42.356,15.38z M24.707,13.58c-0.969-0.592-2.185-0.694-3.648-0.307
                    c-1.458,0.387-2.461,1.081-3.011,2.081c-0.548,1.001-0.618,2.258-0.208,3.771c0.415,1.529,1.114,2.592,2.101,3.188
                    c0.985,0.596,2.199,0.703,3.641,0.321c1.463-0.388,2.465-1.08,3.009-2.078c0.542-0.996,0.607-2.26,0.193-3.789
                    C26.368,15.234,25.675,14.172,24.707,13.58z M24.253,19.578c-0.189,0.508-0.598,0.845-1.226,1.012
                    c-1.236,0.327-2.092-0.388-2.568-2.146c-0.481-1.774-0.099-2.826,1.146-3.156c0.612-0.162,1.131-0.067,1.556,0.284
                    c0.426,0.352,0.762,0.981,1.008,1.89C24.413,18.365,24.441,19.071,24.253,19.578z"/>
                    </g>
                    </g>
                    </svg>


                    </a>

                      <div class='plugin-button'>
                        <span>Flag as</span>
                        <svg viewBox="0 0 100 80">
                          <path fill-rule="evenodd" clip-rule="evenodd" d="M85.759,55.925H5.852C2.62,55.925,0,53.292,0,50.044V18.121
                          c0-3.249,2.62-5.881,5.852-5.881h79.907c3.231,0,5.852,2.633,5.852,5.881v31.923C91.61,53.292,88.99,55.925,85.759,55.925z
                          M26.56,32.285h-7.525v3.656h3.112v2.745c-0.588,0.135-1.232,0.205-1.932,0.205c-1.28,0-2.26-0.43-2.939-1.289
                          c-0.68-0.859-1.02-2.108-1.02-3.746c0-1.67,0.375-2.954,1.127-3.854c0.751-0.898,1.814-1.347,3.19-1.347
                          c1.503,0,2.881,0.312,4.139,0.934l1.49-3.715c-0.724-0.319-1.573-0.583-2.546-0.792c-0.974-0.208-2.009-0.311-3.106-0.311
                          c-2.894,0-5.145,0.787-6.75,2.36c-1.606,1.575-2.409,3.776-2.409,6.605c0,2.9,0.733,5.133,2.201,6.7
                          c1.466,1.566,3.543,2.35,6.231,2.35c2.448,0,4.694-0.352,6.738-1.056V32.285z M44.281,27.035c-1.431-1.527-3.534-2.29-6.309-2.29
                          c-2.766,0-4.875,0.77-6.326,2.308c-1.45,1.539-2.176,3.766-2.176,6.683c0,2.949,0.729,5.193,2.189,6.736
                          c1.458,1.541,3.556,2.313,6.291,2.313c2.775,0,4.88-0.768,6.32-2.303c1.438-1.533,2.158-3.775,2.158-6.723
                          C46.428,30.803,45.712,28.562,44.281,27.035z M66.177,25.021h-4.197v7.923c0,1.07,0.055,2.489,0.166,4.254h-0.07L55.73,25.021
                          h-6.153v17.524h4.174v-7.898c0-1.024-0.076-2.506-0.228-4.447h0.107l6.368,12.346h6.178V25.021z M80.298,38.686h-5.641v-3.308h5.223
                          v-3.799h-5.223v-2.757h5.641v-3.8H69.946v17.524h10.352V38.686z M37.95,38.842c-2.346,0-3.518-1.695-3.518-5.082
                          c0-3.421,1.181-5.131,3.541-5.131c1.162,0,2.035,0.417,2.618,1.252c0.585,0.835,0.878,2.128,0.878,3.879
                          c0,1.741-0.288,3.024-0.864,3.847C40.025,38.431,39.141,38.842,37.95,38.842z M40.627,3.529C40.627,1.58,42.199,0,44.137,0h3.338
                          c1.939,0,3.512,1.58,3.512,3.529v4.376h-10.36V3.529z M50.987,86.003h-10.36V60.929h10.36V86.003z"/>
                        </svg>
                      </div>
                    </div>
                   </div>"""

listingUI = """<div class='plugin-wrapper-listing'>
                <div class='plugin-unavailable'><span>

                <svg viewBox="0 0 50 40">
                <g>
                <g>
                <path d="M52.89,18.903L48.404,2.343c-0.457-1.686-2.208-2.686-3.912-2.234L2.368,11.273c-1.704,0.452-2.715,2.184-2.258,3.869
                l4.486,16.562c0.457,1.685,2.208,2.685,3.912,2.233l42.125-11.165C52.335,22.32,53.347,20.589,52.89,18.903z M50.163,21.042
                L8.039,32.208c-0.737,0.195-1.496-0.239-1.694-0.968L1.859,14.679C1.662,13.95,2.1,13.199,2.837,13.004L44.961,1.839
                c0.737-0.195,1.496,0.238,1.693,0.967l4.486,16.562C51.338,20.096,50.9,20.847,50.163,21.042z M12.135,19.831l0.514,1.896
                l1.641-0.435l0.386,1.424c-0.292,0.152-0.621,0.278-0.99,0.376c-0.675,0.179-1.252,0.093-1.731-0.258s-0.833-0.951-1.064-1.801
                c-0.234-0.867-0.217-1.586,0.053-2.157c0.27-0.571,0.767-0.952,1.492-1.145c0.792-0.21,1.562-0.241,2.313-0.094l0.264-2.136
                c-0.426-0.064-0.911-0.083-1.454-0.055s-1.103,0.119-1.682,0.272c-1.525,0.404-2.601,1.127-3.227,2.168s-0.74,2.296-0.342,3.763
                c0.407,1.505,1.108,2.562,2.102,3.169c0.993,0.607,2.198,0.724,3.615,0.348c1.291-0.342,2.425-0.838,3.404-1.489l-1.327-4.899
                L12.135,19.831z M33.753,10.062l1.114,4.11c0.15,0.555,0.379,1.283,0.686,2.184l-0.037,0.01l-5.056-5.431l-3.244,0.859
                l2.463,9.092l2.2-0.584l-1.11-4.098c-0.144-0.53-0.393-1.289-0.745-2.274l0.057-0.016l5.092,5.515l3.256-0.863l-2.462-9.091
                L33.753,10.062z M42.356,15.38l-0.465-1.717l2.754-0.729l-0.534-1.971l-2.753,0.729l-0.387-1.43l2.974-0.789l-0.534-1.971
                l-5.458,1.446l2.463,9.091l5.457-1.446l-0.542-2.002L42.356,15.38z M24.707,13.58c-0.969-0.592-2.185-0.694-3.648-0.307
                c-1.458,0.387-2.461,1.081-3.011,2.081c-0.548,1.001-0.618,2.258-0.208,3.771c0.415,1.529,1.114,2.592,2.101,3.188
                c0.985,0.596,2.199,0.703,3.641,0.321c1.463-0.388,2.465-1.08,3.009-2.078c0.542-0.996,0.607-2.26,0.193-3.789
                C26.368,15.234,25.675,14.172,24.707,13.58z M24.253,19.578c-0.189,0.508-0.598,0.845-1.226,1.012
                c-1.236,0.327-2.092-0.388-2.568-2.146c-0.481-1.774-0.099-2.826,1.146-3.156c0.612-0.162,1.131-0.067,1.556,0.284
                c0.426,0.352,0.762,0.981,1.008,1.89C24.413,18.365,24.441,19.071,24.253,19.578z"/>
                </g>
                </g>
                </svg>

                </span></div>
                <div class="plugin-button-wrapper">
                  <div class='plugin-button'>
                    <span>Flag as</span>
                    <svg viewBox="0 0 100 80">
                      <path fill-rule="evenodd" clip-rule="evenodd" d="M85.759,55.925H5.852C2.62,55.925,0,53.292,0,50.044V18.121
                      c0-3.249,2.62-5.881,5.852-5.881h79.907c3.231,0,5.852,2.633,5.852,5.881v31.923C91.61,53.292,88.99,55.925,85.759,55.925z
                      M26.56,32.285h-7.525v3.656h3.112v2.745c-0.588,0.135-1.232,0.205-1.932,0.205c-1.28,0-2.26-0.43-2.939-1.289
                      c-0.68-0.859-1.02-2.108-1.02-3.746c0-1.67,0.375-2.954,1.127-3.854c0.751-0.898,1.814-1.347,3.19-1.347
                      c1.503,0,2.881,0.312,4.139,0.934l1.49-3.715c-0.724-0.319-1.573-0.583-2.546-0.792c-0.974-0.208-2.009-0.311-3.106-0.311
                      c-2.894,0-5.145,0.787-6.75,2.36c-1.606,1.575-2.409,3.776-2.409,6.605c0,2.9,0.733,5.133,2.201,6.7
                      c1.466,1.566,3.543,2.35,6.231,2.35c2.448,0,4.694-0.352,6.738-1.056V32.285z M44.281,27.035c-1.431-1.527-3.534-2.29-6.309-2.29
                      c-2.766,0-4.875,0.77-6.326,2.308c-1.45,1.539-2.176,3.766-2.176,6.683c0,2.949,0.729,5.193,2.189,6.736
                      c1.458,1.541,3.556,2.313,6.291,2.313c2.775,0,4.88-0.768,6.32-2.303c1.438-1.533,2.158-3.775,2.158-6.723
                      C46.428,30.803,45.712,28.562,44.281,27.035z M66.177,25.021h-4.197v7.923c0,1.07,0.055,2.489,0.166,4.254h-0.07L55.73,25.021
                      h-6.153v17.524h4.174v-7.898c0-1.024-0.076-2.506-0.228-4.447h0.107l6.368,12.346h6.178V25.021z M80.298,38.686h-5.641v-3.308h5.223
                      v-3.799h-5.223v-2.757h5.641v-3.8H69.946v17.524h10.352V38.686z M37.95,38.842c-2.346,0-3.518-1.695-3.518-5.082
                      c0-3.421,1.181-5.131,3.541-5.131c1.162,0,2.035,0.417,2.618,1.252c0.585,0.835,0.878,2.128,0.878,3.879
                      c0,1.741-0.288,3.024-0.864,3.847C40.025,38.431,39.141,38.842,37.95,38.842z M40.627,3.529C40.627,1.58,42.199,0,44.137,0h3.338
                      c1.939,0,3.512,1.58,3.512,3.529v4.376h-10.36V3.529z M50.987,86.003h-10.36V60.929h10.36V86.003z"/>
                    </svg>
                  </div>
                </div>
               </div>"""

updateAvailability = ->
  listingIds = []

  for listingId of listings
    listingIds.push(ID_PREFIX + listingId)

  sendMessage(SEARCH_LISTING_IDS, listingIds, (unavailableListings) ->
    for listing in unavailableListings
      for id in listing['property_ids']
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
#  ui.closest('li').animate({'opacity': 0.3})
  ui.find('.plugin-button span').fadeOut(()->
    ui.find('.plugin-button').addClass('unavailable')
    ui.find('.plugin-button span').text('Flag as not').fadeIn()
  )

setVisiblyAvailable = (ui) ->
  ui.find('.plugin-unavailable').fadeOut()
#  ui.closest('li').animate({'opacity': 1})

  ui.find('.plugin-button span').fadeOut( ->
    ui.find('.plugin-button span').text('Flag as').fadeIn()
    ui.find('.plugin-button').removeClass('unavailable')
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