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
  window.gyoryangLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: "http://172.30.1.33:8081/geoserver/wms",
      params: { "LAYERS": "dbdbdb:gyoryang", "TILED": true },
      serverType: "geoserver", transition: 0
    }), 
    visible: false
  });
  map.addLayer(window.gyoryangLayer);
  bindToggle("btnBridge", window.gyoryangLayer);

  map.on("singleclick", function(evt) {
    if (!window.gyoryangLayer.getVisible()) return;
    var url = window.gyoryangLayer.getSource().getFeatureInfoUrl(
      evt.coordinate, map.getView().getResolution(),
      "EPSG:3857", { INFO_FORMAT: "application/json" }
    );

    if (url) {
      fetch(url)
        .then(function(r) { return r.json(); })
        .then(function(json) {
          if (json.features && json.features.length > 0) {
            var props = json.features[0].properties;
            console.log("속성:", props);
            console.log("교량 UFID:", props.ufid);
            var nameVal = props.name || "(이름 없음)";
			var ufidVal = props.ufid;
           
            var KIND_MAP = { BRK000: "미분류", BRK001: "도로교", BRK002: "보도교", BRK003: "철교" };
            var kindVal = KIND_MAP[props.kind] || "미상";

            var QUAL_MAP = { BRQ000: "미분류", BRQ001: "콘크리트", BRQ002: "강재", BRQ003: "목재", BRQ004: "석재", BRQ005: "기타" };
            var qualVal = QUAL_MAP[props.qual] || "미상";

            // 1) 팝업 기본 골격 (inspBox 비워두기)
            popupEl.innerHTML =
              '<div><b>교량명:</b> ' + nameVal +
              '<br><b>고유번호:</b> ' + ufidVal + 
              '<br><b>용도:</b> ' + kindVal +
              '<br><b>구조:</b> ' + qualVal + '</div>' +
              '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">' +
                '안전진단표 불러오는 중...' +
              '</div>' +
              '<div style="margin-top:6px; display:flex; gap:6px;">' +
                '<button id="btnBridgeDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
                '<button id="btnBridgeInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
              '</div>';

            overlay.setPosition(evt.coordinate);

            // 버튼 이벤트
            document.getElementById("btnBridgeDetail")?.addEventListener("click", function() {
              window.open("/bridge/detail?id=" + props.id, "_blank", "width=1000,height=800");
            });
            document.getElementById("btnBridgeInspect")?.addEventListener("click", function() {
              window.open("/bridge/inspect?id=" + props.id, "_blank", "width=1200,height=900");
            });

            // 2) 안전진단표 조회
            var bridgeId = props.ufid;

            console.log("선택된 UFID:", bridgeId);

            if (bridgeId) {
              fetch("${pageContext.request.contextPath}/api/damage/" + bridgeId + "/inspection")
                .then(function(r) { return r.json(); })
                .then(function(map) {
				  var inspBox = document.getElementById("inspBox");
				
				  // API가 에러 JSON을 반환한 경우 체크
				  if (!map || map.error || map.status >= 400) {
				    inspBox.innerHTML = "<div style='color:red;'>점검표 불러오기 실패</div>";
				    return;
				  }
				
				  if (Object.keys(map).length === 0) {
				    inspBox.innerHTML = "<div>점검 이력 없음</div>";
				  } else {
				    var html = '<table class="table table-sm table-bordered mb-0">';
				    html += "<thead><tr><th>손상유형</th><th>등급</th></tr></thead><tbody>";
				    for (var key in map) {
				      if (map.hasOwnProperty(key)) {
				        var value = map[key];
				        html += "<tr><td>" + key + "</td><td>" + (value != null && value !== "" ? value : '-') + "</td></tr>";
				      }
				    }
				    html += "</tbody></table>";
				    inspBox.innerHTML = html;
				  }
				})
                .catch(function(err) {
                  console.error("점검표 로드 오류:", err);
                  document.getElementById("inspBox").innerHTML =
                    "<div style='color:red;'>점검표 불러오기 실패</div>";
                });
            }

          }/*  else {
            overlay.setPosition(undefined);
          } */
        })
        .catch(function(err) {
          console.error("GetFeatureInfo 에러:", err);
          overlay.setPosition(undefined);
        });
    }
  });
</script>

</body>
</html>