<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>OpenLayers 기본</title>
  <link
    rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css"
  />
  <script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
  <style>
    #map {
      width: 100%;
      height: 100vh;
    }
  </style>
</head>
<body>
  <div id="map"></div>

  <script>
    const map = new ol.Map({
      target: 'map',
      layers: [
        new ol.layer.Tile({
          source: new ol.source.OSM(),
        }),
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]),
        zoom: 12,
      }),
    });
  </script>
</body>
</html>
