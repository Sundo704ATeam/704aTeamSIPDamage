<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>철도 레이어</title>
</head>
<body>
<script>
  // 1) 철도 레이어 (WFS + 회색 스타일)
  window.cheoldoLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      url: "http://172.30.1.33:8081/geoserver/wfs?service=WFS&version=1.0.0&" +
           "request=GetFeature&typeName=dbdbdb:cheoldo_shifted2&outputFormat=application/json&srsName=EPSG:3857",
      format: new ol.format.GeoJSON()
    }),
    style: new ol.style.Style({
      stroke: new ol.style.Stroke({ color: '#666', width: 2 }),   // 테두리 진회색
      fill: new ol.style.Fill({ color: 'rgba(128,128,128,0.5)' }) // 회색 반투명
    }),
    visible: false
  });
  map.addLayer(cheoldoLayer);
  bindToggle("btnCheoldo", cheoldoLayer);

  // 2) 클릭 이벤트 (WFS 피처 직접 조회)
  map.on("singleclick", evt => {
    map.forEachFeatureAtPixel(evt.pixel, (feature, layer) => {
      if (layer !== cheoldoLayer) return;

      const props = feature.getProperties();
      const nameVal = props.dgm_nm || "(이름 없음)";
      const ufidVal = props.present_sn;

      // 팝업 HTML
      popupEl.innerHTML =
        '<div><b>철도명:</b> ' + nameVal +
        '<br><b>고유번호:</b> ' + ufidVal + '</div>' +
        '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">' +
          '안전진단표 불러오는 중...' +
        '</div>' +
        '<div style="margin-top:6px; display:flex; gap:6px;">' +
          '<button id="btnRailDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
          '<button id="btnRailInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
        '</div>';

      overlay.setPosition(evt.coordinate);

      // 버튼 이벤트
      document.getElementById("btnRailDetail")?.addEventListener("click", () => {
        window.open("/rail/detail?id=" + props.id, "_blank", "width=1000,height=800");
      });
      document.getElementById("btnRailInspect")?.addEventListener("click", () => {
        window.open("/rail/inspect?id=" + props.id, "_blank", "width=1200,height=900");
      });

      // 3) 안전진단표 조회
      if (ufidVal) {
        fetch("${pageContext.request.contextPath}/api/damage/" + ufidVal + "/inspection")
          .then(r => r.json())
          .then(map => {
            const inspBox = document.getElementById("inspBox");

            if (!map || map.error || map.status >= 400) {
              inspBox.innerHTML = "<div style='color:red;'>점검표 불러오기 실패</div>";
              return;
            }

            if (Object.keys(map).length === 0) {
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