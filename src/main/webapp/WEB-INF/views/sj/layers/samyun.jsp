<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>절토사면</title>
</head>
<body>
  <script>
    // ✅ GeoServer WFS 레이어 (절토사면만 가져오기)
    const samyunLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        url: function(extent) {
          return 'http://172.30.1.33:8081/geoserver/dbdbdb/ows?' +
                 'service=WFS&version=1.0.0&request=GetFeature&' +
                 'typeName=dbdbdb:slope&outputFormat=application/json&' +
                 'srsName=EPSG:3857&' 
        },
        format: new ol.format.GeoJSON()
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 10,
          fill: new ol.style.Fill({ color: 'brown' }),
          stroke: new ol.style.Stroke({ color: 'brown', width: 2 })
        })
      }),
      visible: false   // 처음엔 안 보이게
    });
    
	map.addLayer(samyunLayer);


    // ✅ 버튼 클릭 시 레이어 토글
    document.getElementById("btnSamyun").addEventListener("click", () => {
      if (!map.getLayers().getArray().includes(samyunLayer)) {
        map.addLayer(samyunLayer);
      }

      samyunLayer.setVisible(!samyunLayer.getVisible());

      const btn = document.getElementById("btnSamyun");
      if (samyunLayer.getVisible()) {
        btn.classList.add("active");
      } else {
        btn.classList.remove("active");
      }
    });

  </script>
</body>
</html>
