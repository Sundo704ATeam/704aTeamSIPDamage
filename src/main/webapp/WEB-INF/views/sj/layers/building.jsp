<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>건축물</title>
</head>
<body>
  <script>
    // ✅ GeoServer WFS 레이어 (건축물만 가져오기)
    const buildingLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        url: function(extent) {
          return 'http://172.30.1.33:8081/geoserver/dbdbdb/ows?' +
                 'service=WFS&version=1.0.0&request=GetFeature&' +
                 'typeName=dbdbdb:building&outputFormat=application/json&' +
                 'srsName=EPSG:3857&' 
        },
        format: new ol.format.GeoJSON()
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 10,
          fill: new ol.style.Fill({ color: 'green' }),
          stroke: new ol.style.Stroke({ color: 'green', width: 2 })
        })
      }),
      visible: false   // 처음엔 안 보이게
    });

	map.addLayer(buildingLayer);

    // ✅ 버튼 클릭 시 레이어 토글
    document.getElementById("btnBuilding").addEventListener("click", () => {
      if (!map.getLayers().getArray().includes(buildingLayer)) {
        map.addLayer(buildingLayer);
      }

      buildingLayer.setVisible(!buildingLayer.getVisible());

      const btn = document.getElementById("btnBuilding");
      if (buildingLayer.getVisible()) {
        btn.classList.add("active");
      } else {
        btn.classList.remove("active");
      }
    });

  </script>
</body>
</html>
