(function() {
  var FLAG_CURRENT_LISTING, RETURN_CURRENT_LISTING, SEARCH_LISTING_IDS, SEARCH_URLS, SET_CURRENT_LISTING, SET_LISTING_AVAILABLE, SET_LISTING_UNAVAILABLE, sendMessage;

  SET_CURRENT_LISTING = 0;

  RETURN_CURRENT_LISTING = 1;

  FLAG_CURRENT_LISTING = 2;

  SEARCH_URLS = 3;

  SEARCH_LISTING_IDS = 4;

  SET_LISTING_UNAVAILABLE = 5;

  SET_LISTING_AVAILABLE = 6;

  sendMessage = function(action, json, callback) {
    if (callback == null) {
      callback = null;
    }
    return chrome.runtime.sendMessage({
      action: action,
      data: json
    }, function(response) {
      if (callback !== null) {
        return callback(response);
      }
    });
  };

  $(function() {
    var address, thumbnail, type;
    address = $("#address");
    type = $("#type");
    thumbnail = $("#thumbnail");
    $("#markUnavailable").click(function() {
      return sendMessage(FLAG_CURRENT_LISTING);
    });
    return sendMessage(RETURN_CURRENT_LISTING, null, function(response) {
      address.text(response.address);
      type.text(response.type);
      return thumbnail.attr("src", response.thumbnail);
    });
  });

}).call(this);
