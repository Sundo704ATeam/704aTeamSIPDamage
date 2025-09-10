<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>OpenLayers + GeoServer</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
<script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
<style>
:root {
  --header-h: 60px;
  --footer-h: 40px;
  --rail-w: 120px;
  --tool-w: 200px;
}
#dataRail {
  position: fixed; z-index: 900;
  top: var(--header-h, 60px);
  left: var(--rail-w);
  bottom: var(--footer-h);
  width: var(--tool-w);
  background: #f3f3f3;
  border-right: 1px solid #ddd;
  padding: 12px 10px;
  display: flex; flex-direction: column; gap: 10px;
  transition: transform .25s ease; will-change: transform;
}
footer {
	position: fixed; left: 0; right: 0; bottom: 0;
	height: var(--footer-h, 40px);
	background: #333; color: #fff;
	display: flex; align-items: center; justify-content: center;
	border-top: 1px solid #444; z-index: 1000;
}
#map {
  position: fixed;
  top: var(--header-h);
  left: calc(var(--rail-w) + var(--tool-w));
  right: 0; bottom: var(--footer-h);
  z-index: 10; min-height: 300px;
}
#dataRail button {
	display: block; width: 100%; padding: 10px 12px;
	text-align: center; border-radius: 10px;
	border: 1px solid #6b7280; background: #fff; color: #111;
}
#dataRail button:hover { background: #e5e7eb; }
body.rail-collapsed #dataRail { transform: translateX(-100%); }
body.rail-collapsed #map { left: var(--rail-w); }
.rail-toggle {
  position: fixed; z-index: 1200; top: 50%;
  transform: translateY(-50%);
  left: calc(var(--rail-w) + var(--tool-w) - 1px);
  width: 18px; height: 80px;
  border: 1px solid #c9ccd1; background: #fff;
  cursor: pointer; user-select: none;
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; line-height: 1;
  transition: left .25s ease, background .15s ease, box-shadow .15s ease, transform .1s ease;
}
.rail-toggle:hover { background: #f6f7f9; box-shadow: 0 4px 8px rgba(0,0,0,.18); }
.rail-toggle:active { transform: translateY(-50%) scale(.97); }
body.rail-collapsed .rail-toggle { left: calc(var(--rail-w) - 1px); }
#dataRail .btn.active { background:#e5e7eb; }

/* 팝업 */
.ol-popup {
  position: absolute; background: white;
  box-shadow: 0 1px 4px rgba(0,0,0,0.2);
  padding: 10px; border-radius: 8px; border: 1px solid #cccccc;
  min-width: 160px;
}
.ol-popup:after, .ol-popup:before {
  top: 100%; border: solid transparent; content: " ";
  height: 0; width: 0; position: absolute; pointer-events: none;
}
.ol-popup:after {
  border-top-color: white; border-width: 10px;
  left: 48px; margin-left: -10px;
}
.ol-popup:before {
  border-top-color: #cccccc; border-width: 11px;
  left: 48px; margin-left: -11px;
}
</style>
</head>
<body>
	<!-- 메뉴 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<jsp:include page="/WEB-INF/views/sidebar.jsp" />
	<div class="d-flex flex-column p-3 h-100"
		style="min-width: 240px; background-color: #2c3e50; color: white;">
		<!-- 시설 선택 -->
		<aside id="dataRail">
			<div style="text-align: center;">
				<label class="form-label text-black">사회기반시설 선택</label>
				<div class="d-grid gap-2">
					<button id="btnBridge" class="btn btn-light btn-sm">교량</button>
					<button id="btnFootbridge" class="btn btn-light btn-sm">육교</button>
					<button id="btnTunnel" class="btn btn-light btn-sm">터널</button>
					<button id="btnStruc" class="btn btn-light btn-sm">건축물</button>
					<button id="btnCheoldo" class="btn btn-light btn-sm">철도</button>
					<button id="btnAll" class="btn btn-light btn-sm">전체 보기</button>
					<button id="btnAlldown" class="btn btn-light btn-sm">전체 해제</button>
				</div>
			</div>
		</aside>
	</div>
<button id="toggleRailBtn" class="rail-toggle" aria-expanded="true" title="데이터레일 접기">◀</button>
<div id="map"></div>

<!-- 팝업 element -->
<div id="popup" class="ol-popup"></div>

<footer>© 사회기반시설 스마트 유지관리 시스템</footer>
<script>
	// 1. Vworld WMTS 배경지도
 const vworldLayer = new ol.layer.Tile({
  source: new ol.source.XYZ({
    url: "http://api.vworld.kr/req/wmts/1.0.0/"
         + "60DA3367-BC75-32D9-B593-D0386112A70C"  // 🔑 API 키
         + "/Base/{z}/{y}/{x}.png"
  })
});
  // 2. 시설물 WMS 레이어들
  const yookgyoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: 'http://172.30.1.33:8081/geoserver/wms',
      params: { 'LAYERS': 'dbdbdb:yookgyo','TILED': true },
      serverType: 'geoserver', transition: 0
    }), visible: false
  });
  const gyoryangLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: 'http://172.30.1.33:8081/geoserver/wms',
      params: { 'LAYERS': 'dbdbdb:gyoryang','TILED': true },
      serverType: 'geoserver', transition: 0
    }), visible: false
  });
  const tunnelLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: 'http://172.30.1.33:8081/geoserver/wms',
      params: { 'LAYERS': 'dbdbdb:tunnel','TILED': true },
      serverType: 'geoserver', transition: 0
    }), visible: false
  });
  const mapoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: 'http://172.30.1.33:8081/geoserver/wms',
      params: { 'LAYERS': 'dbdbdb:mapo','TILED': true },
      serverType: 'geoserver', transition: 0
    }), visible: false
  });
  const cheoldoLayer = new ol.layer.Tile({
    source: new ol.source.TileWMS({
      url: 'http://172.30.1.33:8081/geoserver/wms',
      params: { 'LAYERS': 'dbdbdb:cheoldo_shifted','TILED': true },
      serverType: 'geoserver', transition: 0
    }), visible: false
  });

  // 3. 지도 생성
  const map = new ol.Map({
    target: 'map',
    layers: [vworldLayer, yookgyoLayer, gyoryangLayer, tunnelLayer, mapoLayer, cheoldoLayer],
    view: new ol.View({
      center: ol.proj.fromLonLat([127.024612, 37.5326]),
      zoom: 12, projection: 'EPSG:3857'
    }),
  });

  // === 레이어 토글 유틸 ===
  function bindToggle(btnId, layer) {
    const btn = document.getElementById(btnId);
    if (!btn) return;
    btn.addEventListener('click', () => {
      const next = !layer.getVisible();
      layer.setVisible(next);
      btn.classList.toggle('active', next);
    });
  }
  bindToggle("btnBridge",     gyoryangLayer);
  bindToggle("btnFootbridge", yookgyoLayer);
  bindToggle("btnTunnel",     tunnelLayer);
  bindToggle("btnStruc",      mapoLayer);
  bindToggle("btnCheoldo",    cheoldoLayer);

  // 전체 보기
  document.getElementById("btnAll")?.addEventListener("click", () => {
    [["btnBridge",gyoryangLayer],["btnFootbridge",yookgyoLayer],["btnTunnel",tunnelLayer],["btnStruc",mapoLayer],["btnCheoldo",cheoldoLayer]]
    .forEach(([id,layer]) => { layer.setVisible(true); document.getElementById(id)?.classList.add("active"); });
  });
  // 전체 해제
  document.getElementById("btnAlldown")?.addEventListener("click", () => {
    [["btnBridge",gyoryangLayer],["btnFootbridge",yookgyoLayer],["btnTunnel",tunnelLayer],["btnStruc",mapoLayer],["btnCheoldo",cheoldoLayer]]
    .forEach(([id,layer]) => { layer.setVisible(false); document.getElementById(id)?.classList.remove("active"); });
  });

  // 데이터레일 접기/펼치기
  const toggleBtn = document.getElementById('toggleRailBtn');
  toggleBtn?.addEventListener('click', () => {
    document.body.classList.toggle('rail-collapsed');
    const collapsed = document.body.classList.contains('rail-collapsed');
    toggleBtn.setAttribute('aria-expanded', String(!collapsed));
    toggleBtn.title = collapsed ? '데이터레일 펼치기' : '데이터레일 접기';
    toggleBtn.textContent = collapsed ? '▶' : '◀';
    setTimeout(() => map.updateSize(), 260);
  });
  window.addEventListener('resize', () => {
    clearTimeout(window.__mapResizeTimer);
    window.__mapResizeTimer = setTimeout(() => map.updateSize(), 150);
  });

  // === 팝업 설정 ===
  const popupEl = document.getElementById('popup');
  const overlay = new ol.Overlay({
    element: popupEl,
    autoPan: true,
    autoPanAnimation: { duration: 250 }
  });
  map.addOverlay(overlay);

  // === 클릭 이벤트: gyoryang에서 name 가져오기 ===
  map.on('singleclick', function(evt) {
    if (!gyoryangLayer.getVisible()) return;

    const viewRes = map.getView().getResolution();
    // 좌표 변환: EPSG:3857 → EPSG:4326
    
	const url = gyoryangLayer.getSource().getFeatureInfoUrl(
	  evt.coordinate,  // 변환하지 않고 그대로
	  viewRes,
	  "EPSG:3857",     // 지도 projection 그대로
	  { INFO_FORMAT: "application/json" }
	);


    console.log("📌 URL:", url);

    if (url) {
      fetch(url)
        .then(r => r.json())
        .then(json => {
          if (json.features && json.features.length > 0) {
            const props = json.features[0].properties;
            console.log("속성:", props);
            const nameVal = props.name || "(이름 없음)";
            popupEl.innerHTML = "<b>교량명:</b> " + nameVal;
            overlay.setPosition(evt.coordinate);
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

  // === 클릭 이벤트: yookgyo에서 name 가져오기 ===
  map.on('singleclick', function(evt) {
    if (!yookgyoLayer.getVisible()) return;

    const viewRes = map.getView().getResolution();
    const url = yookgyoLayer.getSource().getFeatureInfoUrl(
      evt.coordinate,
      viewRes,
      "EPSG:3857",
      { INFO_FORMAT: "application/json" }
    );

    console.log("📌 URL:", url);

    if (url) {
      fetch(url)
        .then(r => r.json())
        .then(json => {
          if (json.features && json.features.length > 0) {
            const props = json.features[0].properties;
            const nameVal = props.name || "(이름 없음)";
            popupEl.innerHTML = "<b>육교명:</b> " + nameVal;
            overlay.setPosition(evt.coordinate);
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

  // === 클릭 이벤트: tunnel에서 name 가져오기 ===
  map.on('singleclick', function(evt) {
    if (!tunnelLayer.getVisible()) return;

    const viewRes = map.getView().getResolution();
    const url = tunnelLayer.getSource().getFeatureInfoUrl(
      evt.coordinate,
      viewRes,
      "EPSG:3857",
      { INFO_FORMAT: "application/json" }
    );

    console.log("📌 URL:", url);

    if (url) {
      fetch(url)
        .then(r => r.json())
        .then(json => {
          if (json.features && json.features.length > 0) {
            const props = json.features[0].properties;
            const nameVal = props.name || "(이름 없음)";
            popupEl.innerHTML = "<b>터널명:</b> " + nameVal;
            overlay.setPosition(evt.coordinate);
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