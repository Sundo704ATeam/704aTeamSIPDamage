<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>즐겨찾기</title>
</head>
<body>
  <script>
  // ✅ 즐겨찾기 레이어 전역 등록
  window.hoshiLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      url: function(extent) {
        return 'http://172.30.1.33:5433/geoserver/dbdbdb/ows?' +
               'service=WFS&version=1.0.0&request=GetFeature&' +
               'typeName=dbdbdb:structurehoshi&outputFormat=application/json&' +
               'srsName=EPSG:3857&';
      },
      format: new ol.format.GeoJSON()
    }),
    style: new ol.style.Style({
      image: new ol.style.Circle({
        radius: 10,
        fill: new ol.style.Fill({ color: 'yellow' }),
        stroke: new ol.style.Stroke({ color: 'yellow', width: 2 })
      })
    }),
    visible: false // 처음에는 안 보이게
  });

  map.addLayer(window.hoshiLayer);
</script>
</body>
</html>
