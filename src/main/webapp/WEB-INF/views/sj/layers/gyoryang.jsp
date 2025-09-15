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
    const gyoryangLayer = new ol.layer.Vector({
      source: new ol.source.Vector({
        url: 'http://172.30.1.33:8081/geoserver/dbdbdb/ows?service=WFS&' +
             'version=1.0.0&request=GetFeature&typeName=dbdbdb:building&' +
             'outputFormat=application/json&srsName=EPSG:3857',
        format: new ol.format.GeoJSON()
      }),
      style: new ol.style.Style({
        image: new ol.style.Circle({
          radius: 10,
          fill: new ol.style.Fill({ color: 'red' }),
          stroke: new ol.style.Stroke({ color: 'black', width: 2 })
        })
      })
    });
    
    // ✅ layer 동작 버튼 (토글)
    document.getElementById("btnGyoryang").addEventListener("click", () => {
      if (!map.getLayers().getArray().includes(gyoryangLayer)) {
        map.addLayer(gyoryangLayer);   // 처음 눌렀을 때만 지도에 추가
      }

      // 현재 visible 상태 반대로 전환
      const current = gyoryangLayer.getVisible();
      gyoryangLayer.setVisible(!current);

      // 버튼 스타일도 같이 토글
      const btn = document.getElementById("btnGyoryang");
      if (gyoryangLayer.getVisible()) {
        btn.classList.add("active");
      } else {
        btn.classList.remove("active");
      }
    });

 // ✅ 싱글클릭 이벤트 → Feature 확대 & 팝업 표시
    map.on("singleclick", function(evt) {
      let found = false;

      map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
        if (layer === gyoryangLayer) {
          let center;

          // 피처 중심 좌표 계산
          if (feature.getGeometry().getType() === "Point") {
            center = feature.getGeometry().getCoordinates();
          } else {
            const extent = feature.getGeometry().getExtent();
            center = ol.extent.getCenter(extent);
          }

          // ✅ 지도 이동 & 줌
          map.getView().animate({
            center: center,
            zoom: 16,   // 건물 단위는 16~18 추천
            duration: 800
          });

          // ✅ 팝업 표시
          const props = feature.getProperties();
         var name = props.name || "(이름 없음)";
         var type = props.type || "(정보 없음)";
         var address = props.address|| "(주소 없음)";
         
          popupOverlay.setPosition(center); // 중심 좌표에 표시
          popupContent.innerHTML =
              "<b>이름:</b> " + name + "<br>"+
              "<b>종류:</b> " + type + "<br>"+
              "<b>소재지:</b> " + address +
              "<div style='margin-top:6px; display:flex; gap:6px;'>" +
                "<button id='btnInspect' class='btn btn-sm btn-primary'>점검 하기</button>" +
                "<button id='btnHistory' class='btn btn-sm btn-secondary'>점검 내역</button>" +
              "</div>";
              
              console.log(props);

          found = true;
        }   
      });

      if (!found) {
        // 피처 클릭 안했으면 팝업 닫기
        popupOverlay.setPosition(undefined);
      }
    });

    </script>
</body>
</html>
