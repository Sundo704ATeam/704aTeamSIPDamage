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
  // 하천 레이어 (WFS 벡터)
  window.hachunLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      url: "http://172.30.1.33:8081/geoserver/wfs?service=WFS&version=1.0.0&" +
           "request=GetFeature&typeName=dbdbdb:river&outputFormat=application/json&srsName=EPSG:3857",
      format: new ol.format.GeoJSON()
    }),
    style: new ol.style.Style({
      stroke: new ol.style.Stroke({ color: 'blue', width: 2 }),
      fill: new ol.style.Fill({ color: 'rgba(135,206,250,0.4)' }) // 하늘색(LightSkyBlue) 반투명
    }),
    visible: false
  });
  map.addLayer(window.hachunLayer);
  bindToggle("btnHachun", window.hachunLayer);

  // 클릭 이벤트 (WFS)
  map.on("singleclick", function(evt) {
    if (!window.hachunLayer.getVisible()) return;

    map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
      if (layer !== window.hachunLayer) return;

      var props = feature.getProperties();
      var nameVal = props.dgm_nm || "(이름 없음)";

      popupEl.innerHTML =
        "<div><b>하천명:</b> " + nameVal + "</div>" +
        "<button class='btn btn-sm btn-primary' style='margin-top:6px;'>상세 보기</button>";

      overlay.setPosition(evt.coordinate);
    });
  });
</script>
</body>
</html>