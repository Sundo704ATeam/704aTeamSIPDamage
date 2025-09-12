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
  window.cheoldoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: "http://172.30.1.33:8081/geoserver/wms",
      params: { "LAYERS": "dbdbdb:cheoldo_shifted2", "TILED": true },
      serverType: "geoserver", transition: 0
    }), visible: false
  });
  map.addLayer(window.cheoldoLayer);
  bindToggle("btnCheoldo", window.cheoldoLayer);

  map.on("singleclick", evt => {
    if (!window.cheoldoLayer.getVisible()) return;
    const url = window.cheoldoLayer.getSource().getFeatureInfoUrl(
      evt.coordinate, map.getView().getResolution(),
      "EPSG:3857", { INFO_FORMAT: "application/json" }
    );
    if (url) {
        fetch(url)
          .then(r => r.json())
          .then(json => {
            if (json.features && json.features.length > 0) {
              var props = json.features[0].properties;
              var nameVal = props.dgm_nm || "(이름 없음)";
              var ufidVal = props.present_sn;
              

              
              popupEl.innerHTML =
              	  '<div><b>철도명:</b> ' + nameVal + 
              	  '<br><b>고유번호:</b> ' + ufidVal + '</div>' +
              	  '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">' +
                  '안전진단표 불러오는 중...' +
              	  '</div>' +
              	  '<div style="margin-top:6px; display:flex; gap:6px;">' +
                  	'<button id="btnBridgeDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
                  	'<button id="btnBridgeInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
                  '</div>';
          	overlay.setPosition(evt.coordinate);
          	
         // 2) 안전진단표 조회
            var railwayId = props.present_sn;

            console.log("선택된 UFID:", railwayId);

            if (railwayId) {
              fetch("${pageContext.request.contextPath}/api/damage/" + railwayId + "/inspection")
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
          	
            } else {
              overlay.setPosition(undefined);
            }
          })
          .catch(err => {
            console.error("GetFeatureInfo 에러:", err);
            overlay.setPosition(undefined);
          });
      }
    });

</script>

</body>
</html>