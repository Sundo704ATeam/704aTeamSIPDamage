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
	--footer-h: 40px;
	--rail-w: 120px; /* 사이드바 */
	--tool-w: 200px; /* 데이터레일 */
}

#dataRail {
	position: fixed;
	z-index: 900;
	top: var(--header-h, 60px);
	left: var(--rail-w); /* 사이드바 오른쪽부터 시작 */
	bottom: var(--footer-h);
	width: var(--tool-w); /* 데이터레일 폭 */
	background: #f3f3f3;
	border-right: 1px solid #ddd;
	padding: 12px 10px;
	display: flex;
	flex-direction: column;
	gap: 10px;
}
footer {
	position: fixed;
	left: 0;
	right: 0;
	bottom: 0;
	height: var(--footer-h, 40px);
	background: #333;
	color: #fff;
	display: flex;
	align-items: center;
	justify-content: center;
	border-top: 1px solid #444;
	z-index: 1000;
}
#map {
  position: fixed;
  top: var(--header-h, 60px);
  left: calc(var(--rail-w) + var(--tool-w)); /* ✓ 120 + 200 = 320px */
  right: 0;
  bottom: var(--footer-h);
  z-index: 1;
}

#dataRail button {
	display: block;
	width: 100%;
	padding: 10px 12px;
	text-align: center;
	border-radius: 10px;
	text-decoration: none;
	border: 1px solid #6b7280;
	background: #fff;
	color: #111;
}

#dataRail a:hover {
	background: #e5e7eb;
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
					<button id="btnAll" class="btn btn-light btn-sm">전체 보기</button>
					<button id="btnAlldown" class="btn btn-light btn-sm">전체 해제</button>
				</div>
			</div>
		</aside>
	</div>

	<div id="map"></div>

	<footer>© 사회기반시설 스마트 유지관리 시스템</footer>
	<script>
    // 1. 베이스맵 (OSM)
    const osmLayer = new ol.layer.Tile({
      source: new ol.source.OSM(),
    });

    // 2-1. 육교(yookgyo) 레이어
    const yookgyoLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:yookgyo', 	
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false   // 처음엔 숨김
    });

    // 2-2. 교량(gyoryang) 레이어
    const gyoryangLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:gyoryang',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });

    // 2-2. 터널(tunnel) 레이어
    const tunnelLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://localhost:1221/geoserver/wms',
        params: {
          'LAYERS': 'gisdb:tunnel',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });
    
    // 3. 지도 생성
    const map = new ol.Map({
      target: 'map',
      layers: [osmLayer, yookgyoLayer, gyoryangLayer, tunnelLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]), // 서울 좌표
        zoom: 12,
        projection: 'EPSG:3857'
      }),
    });

    //사이드바 버튼과 연동
    //교량 선택
    document.getElementById("btnBridge")?.addEventListener("click", function() {
   	  gyoryangLayer.setVisible(true);
      yookgyoLayer.setVisible(false);     
      tunnelLayer.setVisible(false);
    });
    
	//육교 선택
    document.getElementById("btnFootbridge")?.addEventListener("click", function() {
      gyoryangLayer.setVisible(false);
      yookgyoLayer.setVisible(true);
      tunnelLayer.setVisible(false);
    });
	
  	//터널 선택
    document.getElementById("btnTunnel")?.addEventListener("click", function() {
      gyoryangLayer.setVisible(false);
      yookgyoLayer.setVisible(false);
      tunnelLayer.setVisible(true);
    });
	
	//전체 보기
    document.getElementById("btnAll")?.addEventListener("click", function() {
      yookgyoLayer.setVisible(true);
      gyoryangLayer.setVisible(true);
      tunnelLayer.setVisible(true);
    });
	
    //전체 해제
    document.getElementById("btnAlldown")?.addEventListener("click", function() {
        gyoryangLayer.setVisible(false);
        yookgyoLayer.setVisible(false);
        tunnelLayer.setVisible(false);
      });
    
  </script>
</body>
</html>
