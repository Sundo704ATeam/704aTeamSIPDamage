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
    }), visible: false
  });
  map.addLayer(window.gyoryangLayer);
  bindToggle("btnBridge", window.gyoryangLayer);

  map.on("singleclick", evt => {
    if (!window.gyoryangLayer.getVisible()) return;
    const url = window.gyoryangLayer.getSource().getFeatureInfoUrl(
      evt.coordinate, map.getView().getResolution(),
      "EPSG:3857", { INFO_FORMAT: "application/json" }
    );
    if (url) {
        fetch(url)
          .then(r => r.json())
          .then(json => {
            if (json.features && json.features.length > 0) {
              const props = json.features[0].properties;
              console.log("속성:", props);
              const nameVal = props.name || "(이름 없음)";
           /* const lengVal = Number(props.leng).toFixed(2) || "미상";
              const widtVal = Number(props.widt).toFixed(2) || "미상";
               */
              const KIND_MAP = {
            		  BRK000: "미분류",
            		  BRK001: "도로교",
            		  BRK002: "보도교",
            		  BRK003: "철교"
            		};
              const kindVal = KIND_MAP[props.kind] || "미상";
              
              const QUAL_MAP = {
            		  BRQ000: "미분류",
            		  BRQ001: "콘크리트",
            		  BRQ002: "강재",
            		  BRQ003: "목재",
            		  BRQ004: "석재",
            		  BRQ005: "기타",
            		};
      		  const qualVal = QUAL_MAP[props.qual] || "미상";
              
              popupEl.innerHTML =
              	  '<div><b>교량명:</b> ' + nameVal + 
              	       /* '<br><b> 길이:</b> ' + lengVal +
              	       '<br><b> 넓이:</b> ' + widtVal +
              	        */
              	       '<br><b> 용도:</b> ' + kindVal +
              	       '<br><b> 구조:</b> ' + qualVal + '</div>' +
              	     '<div style="margin-top:6px; display:flex; gap:6px;">' +
              	    '<button id="btnBridgeDetail" class="btn btn-sm btn-primary">상세 보기</button>' +
             	    '<button id="btnBridgeInspect" class="btn btn-sm btn-danger">점검 하기</button>' +
              	  	'</div>';
              	overlay.setPosition(evt.coordinate);
              	
                // 상세 보기 버튼 이벤트
                document.getElementById("btnBridgeDetail")?.addEventListener("click", () => {
                  window.open("/bridge/detail?id=" + props.id, "_blank", "width=1000,height=800");
                });

                // 점검 하기 버튼 이벤트
                document.getElementById("btnBridgeInspect")?.addEventListener("click", () => {
                  window.open("/bridge/inspect?id=" + props.id, "_blank", "width=1200,height=900");
                });

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