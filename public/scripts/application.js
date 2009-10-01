var map = null;
var geocoder = null;

function each(ary, block) {
  for (i in ary) {
    block(ary[i]);
  }
}

function findAddress(address, callback) {
  if (geocoder) {
    var callback = callback;
    geocoder.getLatLng(
      address,
      function(point) {
        if (!point) {
          alert(address + " not found");
        } else {
          callback(point);
        }
      }
    );
  }
}

function initialize() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.setCenter(new GLatLng(58.768, 7.119), 4);
    var mapControl = new GLargeMapControl();
    map.addControl(mapControl);
    geocoder = new GClientGeocoder();
    seedMap();
  }
}

function placeMarker(point, text) {
  var text = text;
  var marker = new GMarker(point);
  map.addOverlay(marker);
  GEvent.addListener(marker, "click", function() {
    marker.openInfoWindowHtml(text);
  });
  return marker;
}

function seedMap() {
  each(["Amsterdam", "Berlin", "Paris", "Madrid", "Den Haag", "Utrecht", "Groningen", "Rome"], function(city) {
    findAddress(city, function(point) {
      placeMarker(point, city);
    });
  })
}

function showAddress(address) {
  var address = address;
  findAddress(address, function(point) {
    map.setCenter(point, 8);
    placeMarker(point, address);
  });
}
