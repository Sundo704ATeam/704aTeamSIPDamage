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
    // ✅ GeoServer WFS 레이어
    const tunnelLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        url: 'http://localhost:1221/geoserver/gisdb/ows?service=WFS&' +
             'version=1.0.0&request=GetFeature&typeName=gisdb:test2&' +
             'outputFormat=application/json&srsName=EPSG:3857',
        format: new ol.format.GeoJSON()
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 10,
          fill: new ol.style.Fill({ color: 'black' }),
          stroke: new ol.style.Stroke({ color: 'black', width: 2 })
        })
      })
    });
    
    // ✅ layer 동작 버튼 (토글)
    document.getElementById("btnTunnel").addEventListener("click", () => {
      if (!map.getLayers().getArray().includes(tunnelLayer)) {
        map.addLayer(tunnelLayer);   // 처음 눌렀을 때만 지도에 추가
      }

      // 현재 visible 상태 반대로 전환
      const current = tunnelLayer.getVisible();
      tunnelLayer.setVisible(!current);

      // 버튼 스타일도 같이 토글
      const btn = document.getElementById("btnTunnel");
      if (tunnelLayer.getVisible()) {
        btn.classList.add("active");
      } else {
        btn.classList.remove("active");
      }
    });

    // ✅ 싱글클릭 이벤트 → 해당 feature로 이동/줌
    map.on("singleclick", function(evt) {
      map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
        if (layer === tunnelLayer) {
          let center;

          // 피처 타입에 따라 중심 좌표 계산
          if (feature.getGeometry().getType() === "Point") {
            center = feature.getGeometry().getCoordinates();
          } else {
            const extent = feature.getGeometry().getExtent();
            center = ol.extent.getCenter(extent);
          }

          // 지도 이동 & 줌
          map.getView().animate({
            center: center,
            zoom: 16,     // 원하는 확대 레벨 (건물 단위는 16~18 추천)
            duration: 800
          });
        }
      });
    });
    </script>
</body>
</html>
