var geocoder;

function load_world_map() {
  if (GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map"));
        map.setCenter(new GLatLng(51.05226693177032, 3.723893165588379), 15);
        map.addControl(new GLargeMapControl());
        map.enableDoubleClickZoom();
        map.enableScrollWheelZoom();
        map.setZoom(1)

        geocoder = new GClientGeocoder();
        //GEvent.addListener(rg, "load", goodresult);
        //GEvent.addListener(rg, "error", badresult);
        //GEvent.addListener(map, "click", handleWorldMapClick);
        GEvent.addListener(map, "click", getLocation);
 }
}

var choosers = new Array();
choosers[0] = 'map_container';
choosers[1] = 'country_select';


// This is very error-prone, terribly hacked IF tree and
// a shame for the author too. Sorry. Those who have force
// on their side should refactor it.
function show_country_chooser(which) {
    for (i in choosers) {
        var chooser = $(choosers[i]);

        if (choosers[i] == which) {
            if (chooser.visible() == false) {
              chooser.show();
              if (choosers[i] == 'map_container') {
                load_world_map();
              }
            } else {
              chooser.hide();
            }
        } else {
            if (chooser.visible()) {
              chooser.squish();
            }
        }
    }
}



function getLocation(overlay, latlng) {
  if (latlng != null) {
    address = latlng;
    geocoder.getLocations(latlng, addCountry);
  }
}

function addCountryFromSelect(combo) {
  call_add_country_ajax(combo.value);
}

function addCountry(response) {
        if (!response || response.Status.code != 200) {
          // TODO - handle errors?
          // alert("Status Code:" + response.Status.code);
        } else {
          //          alert(place.AddressDetails.Country.CountryNameCode);
            place = response.Placemark[0];
            point = new GLatLng(place.Point.coordinates[1], place.Point.coordinates[0]);
            marker = new GMarker(point);
            call_add_country_ajax(place.AddressDetails.Country.CountryNameCode);
        }
}


