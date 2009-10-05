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
    map.setCenter(new GLatLng(54.0, -6.24), 4);
    var mapControl = new GLargeMapControl();
    map.addControl(mapControl);
    geocoder = new GClientGeocoder();
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

function tag(name, content) {
  return "<" + name + ">" + content + "</" + name + ">"
}

function addUserGroupMarker(name, city, country) {
  var name = name;
  var address = city + ", " + country
  findAddress(address, function(point) {
    html = tag('h3', name) + tag('p', address)
    placeMarker(point, html);
  })
} 

function showAddress(address) {
  var address = address;
  findAddress(address, function(point) {
    map.setCenter(point, 8);
    placeMarker(point, address);
  });
}
