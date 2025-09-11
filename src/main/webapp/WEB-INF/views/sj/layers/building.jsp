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
  window.mapoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: "http://172.30.1.33:8081/geoserver/wms",
      params: { "LAYERS": "dbdbdb:mapo", "TILED": true },
      serverType: "geoserver", transition: 0
    }), visible: false
  });
  map.addLayer(window.mapoLayer);
  bindToggle("btnStruc", window.mapoLayer);

  map.on("singleclick", evt => {
    if (!window.mapoLayer.getVisible()) return;
    const url = window.mapoLayer.getSource().getFeatureInfoUrl(
      evt.coordinate, map.getView().getResolution(),
      "EPSG:3857", { INFO_FORMAT: "application/json" }
    );
    if (url) {
        fetch(url)
          .then(r => r.json())
          .then(json => {
            if (json.features && json.features.length > 0) {
              const props = json.features[0].properties;
              const nameVal = props.a13 || "(이름 없음)";
              popupEl.innerHTML =
              	  '<div><b>건물명:</b> ' + nameVal + '</div>' +
              	  '<button class="btn btn-sm btn-primary" style="margin-top:6px;">상세 보기</button>';
          	overlay.setPosition(evt.coordinate);
            } else {
              overlay.setPosition(undefined);
            }
          })
          .catch(err => {
            console.error("GetFeatureInfo 에러:", err);
            overlay.setPosition(undefined);
          });
      }
    });
</script>

</body>
</html>