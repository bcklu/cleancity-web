var map;
var geocoder;
var marker;

$(document).ready(function(){
  geocoder = new google.maps.Geocoder();
});

function dynamic_gmap_with_marker(container, latitude, longitude, text) {
  var latlng = new google.maps.LatLng(latitude, longitude);
  var myOptions = {
    zoom: 14,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById(container), myOptions);
  marker = new google.maps.Marker({
    position: latlng,
    draggable: true,
    animation: google.maps.Animation.DROP,          
    title:text
  });
  marker.setMap(map);
}

function static_gmap_with_marker(container, latitude, longitude, text) {
  var latlng = new google.maps.LatLng(latitude, longitude);
  var myOptions = {
    zoom: 14,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById(container), myOptions);
  marker = new google.maps.Marker({
    position: latlng,
    draggable: false,
    animation: google.maps.Animation.DROP,          
    title:text
  });
  marker.setMap(map);
}


function addMarkerChangedListener(lat_elem, lng_elem)
{
  google.maps.event.addListener(marker, 'position_changed', function() {
    document.getElementById(lat_elem).value = marker.getPosition().lat();
    document.getElementById(lng_elem).value = marker.getPosition().lng();
  });
}


function update_map_by_address( address ) {
  geocoder.geocode( { 'address': address}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      map.setCenter(results[0].geometry.location);
      marker.setPosition(results[0].geometry.location);
    } else {
      alert("Geocode was not successful for the following reason: " + status);
    }
  });
}
