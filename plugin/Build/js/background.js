(function() {
  var API_URL, FLAG_CURRENT_LISTING, REGISTER_USER, RETURN_CURRENT_LISTING, SEARCH_LISTING_IDS, SEARCH_URLS, SET_CURRENT_LISTING, SET_LISTING_AVAILABLE, SET_LISTING_UNAVAILABLE, currentListing, flagCurrentListing, onMessage, registerUser, searchListingIds, setListingAvailable, setListingUnavailable;

  SET_CURRENT_LISTING = 0;

  RETURN_CURRENT_LISTING = 1;

  FLAG_CURRENT_LISTING = 2;

  SEARCH_URLS = 3;

  SEARCH_LISTING_IDS = 4;

  SET_LISTING_UNAVAILABLE = 5;

  SET_LISTING_AVAILABLE = 6;

  REGISTER_USER = 7;

  currentListing = null;

  API_URL = "http://localhost:3000";

  flagCurrentListing = function() {
    if (currentListing === null) {
      return;
    }
    return $.post(API_URL + '/listings', currentListing, function(response) {
      return console.log("Success", response);
    }, function(error) {
      return console.log("Error", error);
    });
  };

  searchListingIds = function(data, callback) {
    return $.ajax(API_URL + '/listings/search.json', {
      type: 'post',
      dataType: 'json',
      data: {
        user_id: data.userId,
        listing_ids: data.data
      },
      success: function(response) {
        console.log("Success", response);
        return callback(response);
      },
      error: function(error) {
        console.log("Error", error);
        return callback([]);
      }
    });
  };

  setListingUnavailable = function(data, callback) {
    return $.ajax(API_URL + '/listings/create_id.json', {
      type: 'post',
      dataType: 'json',
      data: {
        user_id: data.userId,
        id: data.data
      },
      success: function(response) {
        console.log("Success", response);
        return callback(response);
      },
      error: function(error) {
        console.log("Error", error);
        return callback([]);
      }
    });
  };

  setListingAvailable = function(data, callback) {
    return $.ajax(API_URL + '/listings/delete_id.json', {
      type: 'delete',
      dataType: 'json',
      data: {
        user_id: data.userId,
        id: data.data
      },
      success: function(response) {
        console.log("Success", response);
        return callback(response);
      },
      error: function(error) {
        console.log("Error", error);
        return callback([]);
      }
    });
  };

  registerUser = function(callback) {
    return $.ajax(API_URL + '/users.json', {
      type: 'post',
      dataType: 'json',
      contentType: 'application/json',
      success: function(response) {
        console.log("Success", response);
        return callback(response);
      },
      error: function(error) {
        console.log("Error", error);
        return callback([]);
      }
    });
  };

  onMessage = function(request, sender, sendResponse) {
    switch (request.action) {
      case SET_CURRENT_LISTING:
        currentListing = request.data;
        console.log(request.data);
        break;
      case RETURN_CURRENT_LISTING:
        sendResponse(currentListing);
        break;
      case FLAG_CURRENT_LISTING:
        flagCurrentListing();
        break;
      case SEARCH_URLS:
        searchUrls(request.data.data, function(listings) {
          return sendResponse(listings);
        });
        break;
      case SEARCH_LISTING_IDS:
        searchListingIds(request.data, function(listings) {
          return sendResponse(listings);
        });
        break;
      case SET_LISTING_UNAVAILABLE:
        setListingUnavailable(request.data, function(listing) {
          return sendResponse();
        });
        break;
      case SET_LISTING_AVAILABLE:
        setListingAvailable(request.data, function(listing) {
          return sendResponse();
        });
        break;
      case REGISTER_USER:
        registerUser(function(user) {
          return sendResponse(user);
        });
        break;
      default:
        console.log("Unknown message");
    }
    return true;
  };

  chrome.runtime.onMessage.addListener(onMessage);

}).call(this);
