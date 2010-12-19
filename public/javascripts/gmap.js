  function dynamic_gmap_with_marker(container, latitude, longitude, text) {
    var latlng = new google.maps.LatLng(latitude, longitude);
    var myOptions = {
      zoom: 14,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById(container), myOptions);
    var marker = new google.maps.Marker({
      position: latlng,
      title:text
    });
    marker.setMap(map);
  }
