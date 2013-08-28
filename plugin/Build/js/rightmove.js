(function() {
  var FLAG_CURRENT_LISTING, ID_PREFIX, REGISTER_USER, RETURN_CURRENT_LISTING, SEARCH_LISTING_IDS, SEARCH_URLS, SET_CURRENT_LISTING, SET_LISTING_AVAILABLE, SET_LISTING_UNAVAILABLE, createUserIfNecessary, injectBarUI, injectListingUI, injectSummaryListUI, listingUI, listings, pluginBarUI, sendMessage, setAvailable, setUnavailable, setVisiblyAvailable, setVisiblyUnavailable, summaryListUI, unavailableListingIds, updateAvailability, userId;

  SET_CURRENT_LISTING = 0;

  RETURN_CURRENT_LISTING = 1;

  FLAG_CURRENT_LISTING = 2;

  SEARCH_URLS = 3;

  SEARCH_LISTING_IDS = 4;

  SET_LISTING_UNAVAILABLE = 5;

  SET_LISTING_AVAILABLE = 6;

  REGISTER_USER = 7;

  listings = {};

  unavailableListingIds = [];

  pluginBarUI = "<div class='plugin-loading-bar'><div class='plugin-bar-wrapper'><img src='data:image/gif;base64,R0lGODlhGAAYAPYAAPHED/////HGGvXXX/nrsvv01v357fXYY/HEEPbefPz56/////LJJfvxyfvxy/LIIfz23/z34fLJJ/HFFPfff/HHHPbbbvbbcPrstPvyzv38+P378vvz1PLMMvTTTfz45fjmnPHIH/rtuPz13PnqrvXXXv389vbaa/LKK/POOP368PjjkvffgfTUVPfghfbddvjnofHFFvvz0PPPPvXWWvXZZfjklvruvvruv/z12vrvw/PQQ/rtuvfhh/npqfjmnvTVWPz45/LLLfjjkPTUUgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH+GkNyZWF0ZWQgd2l0aCBhamF4bG9hZC5pbmZvACH5BAAFAAAAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAGAAYAAAHmoAAgoOEhYaHgxUWBA4aCxwkJwKIhBMJBguZmpkqLBOUDw2bo5kKEogMEKSkLYgIoqubK5QJsZsNCIgCCraZBiiUA72ZJZQABMMgxgAFvRyfxpixGx3LANKxHtbNth8hy8i9IssHwwsXxgLYsSYpxrXDz5QIDubKlAwR5q2UErC2poxNoLBukwoX0IxVuIAhQ6YRBC5MskaxUCAAIfkEAAUAAQAsAAAAABgAGAAAB6GAAIKDhIWGh4MVFgQOGhsOGAcxiIQTCQYLmZqZGwkIlA8Nm6OaMgyHDBCkqwsjEoUIoqykNxWFCbOkNoYCCrmaJjWHA7+ZHzOIBMUND5QFvzATlACYsy/TgtWsIpPTz7kyr5TKv8eUB8ULGzSIAtq/CYi46Qswn7AO9As4toUMEfRcHZIgC9wpRBMovNvU6d60ChcwZFigwYGIAwKwaUQUCAAh+QQABQACACwAAAAAGAAYAAAHooAAgoOEhYaHgxUWBA4aCzkkJwKIhBMJBguZmpkqLAiUDw2bo5oyEocMEKSrCxCnhAiirKs3hQmzsy+DAgq4pBogKIMDvpvAwoQExQvHhwW+zYiYrNGU06wNHpSCz746O5TKyzwzhwfLmgQphQLX6D4dhLfomgmwDvQLOoYMEegRyApJkIWLQ0BDEyi426Six4RtgipcwJAhUwQCFypA3IgoEAAh+QQABQADACwAAAAAGAAYAAAHrYAAgoOEhYaHgxUWBA4aCxwkJzGIhBMJBguZmpkGLAiUDw2bo5oZEocMEKSrCxCnhAiirKsZn4MJs7MJgwIKuawqFYIDv7MnggTFozlDLZMABcpBPjUMhpisJiIJKZQA2KwfP0DPh9HFGjwJQobJypoQK0S2B++kF4IC4PbBt/aaPWA5+CdjQiEGEd5FQHFIgqxcHF4dmkBh3yYVLmx5q3ABQ4ZMBUhYEOCtpLdAACH5BAAFAAQALAAAAAAYABgAAAeegACCg4SFhoeDFRYEDhoaDgQWFYiEEwkGC5mamQYJE5QPDZujmg0PhwwQpKsLEAyFCKKsqw0IhAmzswmDAgq5rAoCggO/sxaCBMWsBIIFyqsRgpjPoybS1KMqzdibBcjcmswAB+CZxwAC09gGwoK43LuDCA7YDp+EDBHPEa+GErK5GkigNIGCulEGKNyjBKDCBQwZMmXAcGESw4uUAgEAIfkEAAUABQAsAAAAABgAGAAAB62AAIKDhIWGh4MVFgQOGgscJCcxiIQTCQYLmZqZBiwIlA8Nm6OaGRKHDBCkqwsQp4QIoqyrGZ+DCbOzCYMCCrmsKhWCA7+zJ4IExaM5Qy2TAAXKQT41DIaYrCYiCSmUANisHz9Az4fRxRo8CUKGycqaECtEtgfvpBeCAuD2wbf2mj1gOfgnY0IhBhHeRUBxSIKsXBxeHZpAYd8mFS5seatwAUOGTAVIWBDgraS3QAAh+QQABQAGACwAAAAAGAAYAAAHooAAgoOEhYaHgxUWBA4aCzkkJwKIhBMJBguZmpkqLAiUDw2bo5oyEocMEKSrCxCnhAiirKs3hQmzsy+DAgq4pBogKIMDvpvAwoQExQvHhwW+zYiYrNGU06wNHpSCz746O5TKyzwzhwfLmgQphQLX6D4dhLfomgmwDvQLOoYMEegRyApJkIWLQ0BDEyi426Six4RtgipcwJAhUwQCFypA3IgoEAAh+QQABQAHACwAAAAAGAAYAAAHoYAAgoOEhYaHgxUWBA4aGw4YBzGIhBMJBguZmpkbCQiUDw2bo5oyDIcMEKSrCyMShQiirKQ3FYUJs6Q2hgIKuZomNYcDv5kfM4gExQ0PlAW/MBOUAJizL9OC1awik9PPuTKvlMq/x5QHxQsbNIgC2r8JiLjpCzCfsA70Czi2hQwR9FwdkiAL3ClEEyi829Tp3rQKFzBkWKDBgYgDArBpRBQIADsAAAAAAAAAAAA='><span>Updating Listings</span></div></div>";

  summaryListUI = "<div class='plugin-wrapper'><a class='plugin-unavailable'><span>Unavailable</span></a><div class='plugin-button'><span>Mark Unavailable</span></div></div>";

  listingUI = "<div class='plugin-wrapper-listing'><div class='plugin-unavailable'><span>Unavailable</span></div><div class='plugin-button'><span>Mark Unavailable</span></div></div>";

  updateAvailability = function() {
    var listingId, listingIds;
    listingIds = [];
    for (listingId in listings) {
      listingIds.push(ID_PREFIX + listingId);
    }
    return sendMessage(SEARCH_LISTING_IDS, listingIds, function(unavailableListings) {
      var cleanedId, id, listing, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = unavailableListings.length; _i < _len; _i++) {
        listing = unavailableListings[_i];
        _results.push((function() {
          var _j, _len1, _ref, _results1;
          _ref = listing['ids'];
          _results1 = [];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            id = _ref[_j];
            cleanedId = id.replace(/\D/g, '');
            if (listings.hasOwnProperty(cleanedId)) {
              setVisiblyUnavailable(listings[cleanedId]);
              _results1.push(unavailableListingIds.push(parseInt(cleanedId)));
            } else {
              _results1.push(void 0);
            }
          }
          return _results1;
        })());
      }
      return _results;
    });
  };

  sendMessage = function(action, json, callback) {
    var requestStartTime;
    if (callback == null) {
      callback = null;
    }
    requestStartTime = new Date().getTime();
    $('.plugin-loading-bar').fadeIn();
    return chrome.runtime.sendMessage({
      action: action,
      data: {
        userId: userId,
        data: json
      }
    }, function(response) {
      var requestTime;
      requestTime = new Date().getTime() - requestStartTime;
      if (requestTime >= 1000) {
        $('.plugin-loading-bar').fadeOut();
      } else {
        setTimeout(function() {
          return $('.plugin-loading-bar').fadeOut();
        }, 1000 - requestTime);
      }
      if (callback !== null) {
        return callback(response);
      }
    });
  };

  setVisiblyUnavailable = function(ui) {
    ui.find('.plugin-unavailable').fadeIn();
    ui.closest('li').animate({
      'opacity': 0.3
    });
    ui.find('.plugin-button').css('background-color', '#2c3e50');
    return ui.find('.plugin-button span').fadeOut(function() {
      return ui.find('.plugin-button span').text('mark available').fadeIn();
    });
  };

  setVisiblyAvailable = function(ui) {
    ui.find('.plugin-unavailable').fadeOut();
    ui.closest('li').animate({
      'opacity': 1
    });
    ui.find('.plugin-button').css('background-color', '');
    return ui.find('.plugin-button span').fadeOut(function() {
      return ui.find('.plugin-button span').text('mark unavailable').fadeIn();
    });
  };

  setUnavailable = function(id, ui) {
    sendMessage(SET_LISTING_UNAVAILABLE, ID_PREFIX + id);
    setVisiblyUnavailable(ui);
    return unavailableListingIds.push(id);
  };

  setAvailable = function(id, ui) {
    sendMessage(SET_LISTING_AVAILABLE, ID_PREFIX + id);
    setVisiblyAvailable(ui);
    return unavailableListingIds.splice(unavailableListingIds.indexOf(id), 1);
  };

  userId = localStorage.getItem('userId');

  createUserIfNecessary = function() {
    if (userId === null) {
      return sendMessage(REGISTER_USER, null, function(user) {
        return localStorage.setItem('userId', user['_id']);
      });
    }
  };

  $(function() {
    return createUserIfNecessary();
  });

  ID_PREFIX = "rightmove_";

  injectBarUI = function() {
    var ui;
    ui = $(pluginBarUI);
    return $(document.body).append(ui);
  };

  injectSummaryListUI = function() {
    var injectionTarget, ui;
    ui = $(summaryListUI);
    injectionTarget = $('.summarymaincontent');
    return injectionTarget.each(function(i, container) {
      var id, listingImg;
      ui = ui.clone();
      container = $(container);
      listingImg = container.find('.photos');
      ui.height(listingImg.height() + 50);
      ui.find('.plugin-unavailable').height(listingImg.height() - 8).hide();
      ui.find('a').attr('href', listingImg.find('a').attr('href'));
      id = parseInt(container.find('a').attr('id').replace(/\D/g, ''));
      listings[id] = ui;
      (function(id, ui) {
        return ui.find('.plugin-button').click(function(e) {
          if (unavailableListingIds.indexOf(id) === -1) {
            return setUnavailable(id, ui);
          } else {
            return setAvailable(id, ui);
          }
        });
      })(id, ui);
      return container.prepend(ui);
    });
  };

  injectListingUI = function() {
    var container, id, ui;
    id = parseInt(window.location.href.replace(/\D/g, ''));
    ui = $(listingUI);
    container = $('#propertydetails');
    ui.height(container.find('#outer').height() + 54);
    ui.find('.plugin-unavailable').height(container.find('#outer').height()).hide();
    listings[id] = ui;
    ui.find('.plugin-button').click(function(e) {
      if (unavailableListingIds.indexOf(id) === -1) {
        return setUnavailable(id, ui);
      } else {
        return setAvailable(id, ui);
      }
    });
    return container.append(ui);
  };

  $(function() {
    injectBarUI();
    if ($('#noResults').length !== 0) {
      return;
    }
    if ($('li[name="summary-list-item"]').length > 0) {
      injectSummaryListUI();
      return updateAvailability();
    } else if ($('.propertydetails').length > 0) {
      injectListingUI();
      return updateAvailability();
    }
  });

}).call(this);
