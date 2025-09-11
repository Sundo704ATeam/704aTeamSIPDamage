<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script>
  window.gyoryangLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: "http://172.30.1.33:8081/geoserver/wms",
      params: { "LAYERS": "dbdbdb:gyoryang", "TILED": true },
      serverType: "geoserver", transition: 0
    }), visible: false
  });
  map.addLayer(window.gyoryangLayer);
  bindToggle("btnBridge", window.gyoryangLayer);

  map.on("singleclick", evt => {
    if (!window.gyoryangLayer.getVisible()) return;
    const url = window.gyoryangLayer.getSource().getFeatureInfoUrl(
      evt.coordinate, map.getView().getResolution(),
      "EPSG:3857", { INFO_FORMAT: "application/json" }
    );
    if (url) {
      fetch(url).then(r => r.json()).then(json => {
        if (json.features.length > 0) {
          const props = json.features[0].properties;
          showPopup(evt.coordinate, "<b>교량명:</b> " + (props.name || "(이름 없음)"));
        }
      });
    }
  });
</script>

</body>
</html>