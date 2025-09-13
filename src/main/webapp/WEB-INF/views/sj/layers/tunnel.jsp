<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>터널 레이어</title>
</head>
<body>
<script>
  // 1) 터널 레이어 (WFS + 파란색 스타일)
  window.tunnelLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      url: "http://172.30.1.33:8081/geoserver/wfs?service=WFS&version=1.0.0&" +
           "request=GetFeature&typeName=dbdbdb:tunnel&outputFormat=application/json&srsName=EPSG:3857",
      format: new ol.format.GeoJSON()
    }),
    style: new ol.style.Style({
      stroke: new ol.style.Stroke({ color: 'blue', width: 2 }),           // 파란색 테두리
      fill: new ol.style.Fill({ color: 'rgba(0,0,255,0.4)' })             // 반투명 파란색 채우기
    }),
    visible: false
  });
  map.addLayer(window.tunnelLayer);
  bindToggle("btnTunnel", window.tunnelLayer);

  // 2) 클릭 이벤트 (WFS용)
  map.on("singleclick", evt => {
    map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      if (layer !== window.tunnelLayer) return; //터널 레이어만 처리 

      const props = feature.getProperties();
      const nameVal = props.name || "(이름 없음)";
      const ufidVal = props.ufid;

      // 팝업 HTML
      popupEl.innerHTML =
        '<div><b>터널명:</b> ' + nameVal +
        '<br><b>도형번호:</b> ' + ufidVal + '</div>' +
        '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">안전진단표 불러오는 중...</div>' +
        '<div style="margin-top:6px; display:flex; gap:6px;">' +
          '<button id="btnTunnelDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
          '<button id="btnTunnelInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
        '</div>';

      overlay.setPosition(evt.coordinate);

      // 버튼 이벤트
      document.getElementById("btnTunnelDetail")?.addEventListener("click", () => {
	    	window.open("${pageContext.request.contextPath}/tunnel/detail?ufid=" + props.ufid, "_blank", "width=500,height=400");
      });
      document.getElementById("btnTunnelInspect")?.addEventListener("click", () => {
        window.open("/tunnel/inspect?ufid=" + props.ufid, "_blank", "width=1200,height=900");
      });

      // 3) 안전진단표 조회
      if (ufidVal) {
        fetch("${pageContext.request.contextPath}/api/damage/" + ufidVal + "/inspection")
          .then(r => r.json())
          .then(map => {
            const inspBox = document.getElementById("inspBox");
            if (!map || Object.keys(map).length === 0) {
              inspBox.innerHTML = "<div>점검 이력 없음</div>";
            } else {
              let html = '<table class="table table-sm table-bordered mb-0">';
              html += "<thead><tr><th>손상유형</th><th>등급</th></tr></thead><tbody>";
              for (var key in map) {
            	  if (map.hasOwnProperty(key)) {
            	    var value = map[key];
            	    html += "<tr><td>" + key + "</td><td>" + (value != null && value !== "" && value !== false ? value : '-') + "</td></tr>";
            	  }
            	}
              html += "</tbody></table>";
              inspBox.innerHTML = html;
            }
          })
          .catch(err => {
            console.error("점검표 로드 오류:", err);
            document.getElementById("inspBox").innerHTML =
              "<div style='color:red;'>점검표 불러오기 실패</div>";
          });
      }
    });
  });
</script>
</body>
</html>