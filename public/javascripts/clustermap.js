var map;
var map_api_url;

function async_clustermap(container, cLat, cLng, zoom, url) {
  map_api_url = url; //'/1/incident_reports.json'; //url;
	map = new GMap2(document.getElementById(container));
	map.addControl(new GSmallMapControl());
	map.setCenter(new GLatLng(cLat, cLng), zoom);
	updateMarkers();
	GEvent.addListener(map,'zoomend',function() {
		updateMarkers();
	});
	GEvent.addListener(map,'moveend',function() {
		updateMarkers();
	});
}

function updateMarkers() {
	//remove the existing points
	map.clearOverlays();
	//create the boundary for the data
  var center = map.getCenter();
//  GLog.write(center);
	var bounds = map.getBounds();
	var southWest = bounds.getSouthWest();
	var northEast = bounds.getNorthEast();
  var lngSpan = northEast.lng() - southWest.lng();
  var latSpan = northEast.lat() - southWest.lat();

	var getVars = 'longitude='+center.lng()+'&latitude='+center.lat()+'&range_x='+latSpan+'&range_y='+lngSpan+"&limit=99999";
  //
	//log the URL for testing
	//GLog.writeUrl(map_api_url+'?'+getVars);
	//retrieve the points using Ajax
	var request = GXmlHttp.create();
	request.open('GET', map_api_url+'?'+getVars, true);
	request.onreadystatechange = function() {
		if (request.readyState == 4) {
			var jscript = request.responseText;
			var points=eval(jscript);
   //   GLog.write(points.length);
			//create each point from the list
      var markers = [];
			for (i in points) {
				var point = new GLatLng(points[i].latitude,points[i].longitude);
				var marker = createMarker(point,points[i].description);
        markers.push(marker);
			}
      var markerCluster = new MarkerClusterer(map, markers);
		}
	}

	request.send(null);
}

function createMarker(point, html) {
  var icon = new GIcon(G_DEFAULT_ICON);
  icon.image = "http://chart.apis.google.com/chart?cht=mm&chs=24x32&chco=FFFFFF,008CFF,000000&ext=.png";
	var marker = new GMarker(point, {icon:icon});
	GEvent.addListener(marker, 'click', function() {
		var markerHTML = html;
		marker.openInfoWindowHtml(markerHTML);
	}); 
	return marker;
}
