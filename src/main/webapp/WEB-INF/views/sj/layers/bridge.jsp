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
	// 1) 교량 레이어 (WFS 벡터, 색상 지정)
	window.gyoryangLayer = new ol.layer.Vector({
  	source: new ol.source.Vector({
    url: "http://172.30.1.33:8081/geoserver/wfs?service=WFS&version=1.0.0&" +
         "request=GetFeature&typeName=dbdbdb:gyoryang&outputFormat=application/json&srsName=EPSG:3857",
    format: new ol.format.GeoJSON()
 	}),
 	style: new ol.style.Style({
    stroke: new ol.style.Stroke({ color: 'red', width: 2 }),
    fill: new ol.style.Fill({ color: 'rgba(255,0,0,0.5)' })
  	}),
 	 visible: false
	});
	map.addLayer(window.gyoryangLayer);
	bindToggle("btnBridge", window.gyoryangLayer);

	// 2) 클릭 이벤트 (WFS용)
	map.on("singleclick", function(evt) {
	  map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
	    if (layer !== gyoryangLayer) return;  // 교량 레이어만 처리

	    const props = feature.getProperties();
	    console.log("속성:", props);

	    var nameVal = props.name || "(이름 없음)";
	    var ufidVal = props.ufid;

	    var KIND_MAP = { BRK000: "미분류", BRK001: "도로교", BRK002: "보도교", BRK003: "철교" };
	    var kindVal = KIND_MAP[props.kind] || "미상";

	    var QUAL_MAP = { BRQ000: "미분류", BRQ001: "콘크리트", BRQ002: "강재", BRQ003: "목재", BRQ004: "석재", BRQ005: "기타" };
	    var qualVal = QUAL_MAP[props.qual] || "미상";

	    // 팝업 HTML
	    popupEl.innerHTML =
	      '<div><b>교량명:</b> ' + nameVal +
	      '<br><b>고유번호:</b> ' + ufidVal + 
	      '<br><b>용도:</b> ' + kindVal +
	      '<br><b>구조:</b> ' + qualVal + '</div>' +
	      '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">안전진단표 불러오는 중...</div>' +
	      '<div style="margin-top:6px; display:flex; gap:6px;">' +
	        '<button id="btnBridgeDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
	        '<button id="btnBridgeInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
	      '</div>';

	    overlay.setPosition(evt.coordinate);

	    // 버튼 이벤트
	    document.getElementById("btnBridgeDetail")?.addEventListener("click", function() {
	    	window.open("${pageContext.request.contextPath}/bridge/detail?ufid=" + props.ufid, "_blank", "width=500,height=400");
	    });
	    document.getElementById("btnBridgeInspect")?.addEventListener("click", function() {
	    	window.open("${pageContext.request.contextPath}/inspect/detail?ufid=" + props.ufid, "_blank", "width=500,height=400");
	    });

	    // 안전진단표 조회
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