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
  --header-h: 60px;   /* 명시적으로 정의해 두세요 */
  --footer-h: 40px;
  --rail-w: 120px;
  --tool-w: 200px;
}
#dataRail {
  position: fixed;
  z-index: 900;               /* sidebar보다 낮고, map보다 높게만 유지 */
  top: var(--header-h, 60px);
  left: var(--rail-w);        /* ← 사이드바 오른쪽부터 시작 (사이드바는 고정) */
  bottom: var(--footer-h);
  width: var(--tool-w);       /* DataRail 폭 */
  background: #f3f3f3;
  border-right: 1px solid #ddd;
  padding: 12px 10px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  

  /* 접기/펼치기 애니메이션 */
  transition: transform .25s ease;
  will-change: transform;
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
  top: var(--header-h);
  left: calc(var(--rail-w) + var(--tool-w)); /* ← 연산 기호 앞뒤 공백 필수 */
  right: 0;
  bottom: var(--footer-h);
  z-index: 10;
  min-height: 300px; /* 안전빵 */
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

#dataRail button:hover {
  background: #e5e7eb;
}

/* DataRail 접힘(숨김) - 사이드바는 그대로 */
body.rail-collapsed #dataRail {
  transform: translateX(-100%);   /* 자기 너비만큼 왼쪽으로 */
}

/* 접히면 지도는 사이드바 너비까지만 띄움 */
body.rail-collapsed #map {
  left: var(--rail-w);
}
.rail-toggle {
  position: fixed;
  z-index: 1200;
  top: 50%;
  transform: translateY(-50%);
  left: calc(var(--rail-w) + var(--tool-w) - 1px); /* DataRail 펼침 상태 */
  width: 18px;        /* 얇게 */
  height: 80px;
  border: 1px solid #c9ccd1;
  background: #fff;
  cursor: pointer;
  user-select: none;

  /* 중앙 정렬 */
  display: flex;
  align-items: center;   /* 세로 중앙 */
  justify-content: center; /* 가로 중앙 */

  font-size: 14px;   /* 화살표 크기 */
  line-height: 1;
  transition: left .25s ease, background .15s ease, box-shadow .15s ease, transform .1s ease;
}
.rail-toggle:hover {
  background: #f6f7f9;
  box-shadow: 0 4px 8px rgba(0,0,0,.18);
}
.rail-toggle:active {
  transform: translateY(-50%) scale(.97);
}

/* 접힘 상태: 사이드바 옆으로 이동 */
body.rail-collapsed .rail-toggle {
  left: calc(var(--rail-w) - 1px);
}

#dataRail .btn.active { background:#e5e7eb; }
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

	<footer>© 사회기반시설 스마트 유지관리 시스템</footer>
	<script>
    // 1. 베이스맵 (OSM)
    const osmLayer = new ol.layer.Tile({
      source: new ol.source.OSM(),
    });

    // 2-1. 육교(yookgyo) 레이어
    const yookgyoLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
        url: 'http://172.30.1.33:8081/geoserver/wms',
        params: {
          'LAYERS': 'dbdbdb:yookgyo', 	
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
        url: 'http://172.30.1.33:8081/geoserver/wms',
        params: {
          'LAYERS': 'dbdbdb:gyoryang',
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
    	  url: 'http://172.30.1.33:8081/geoserver/wms',
        params: {
          'LAYERS': 'dbdbdb:tunnel',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });
    
    // 2-3. 마포건축물 레이어
    const mapoLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
   	  	url: 'http://172.30.1.33:8081/geoserver/wms',
        params: {
          'LAYERS': 'dbdbdb:mapo',
          'TILED': true
        },
        serverType: 'geoserver',
        transition: 0
      }),
      visible: false  
    });
    
    // 2-3. 철도 레이어
     const cheoldoLayer = new ol.layer.Tile({
      source: new ol.source.TileWMS({
   	  	url: 'http://172.30.1.33:8081/geoserver/wms',
        params: {
          'LAYERS': 'dbdbdb:cheoldo_shifted',
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
      layers: [osmLayer, yookgyoLayer, gyoryangLayer, tunnelLayer, mapoLayer,cheoldoLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]), // 서울 좌표
        zoom: 12,
        projection: 'EPSG:3857'
      }),
    });

 // === 레이어 토글 유틸 ===
    function bindToggle(btnId, layer) {
      const btn = document.getElementById(btnId);
      if (!btn) return;
      btn.addEventListener('click', () => {
        const next = !layer.getVisible();
        layer.setVisible(next);
        // 버튼 상태 표시(부트스트랩과 어울리게 active 토글)
        btn.classList.toggle('active', next);
      });
    }

    // 개별 토글: 상태 유지 + 다시 누르면 끄기
    bindToggle("btnBridge",     gyoryangLayer);
    bindToggle("btnFootbridge", yookgyoLayer);
    bindToggle("btnTunnel",     tunnelLayer);
    bindToggle("btnStruc",      mapoLayer);
    bindToggle("btnCheoldo",    cheoldoLayer);

    // 전체 보기
    document.getElementById("btnAll")?.addEventListener("click", () => {
      const pairs = [
        ["btnBridge",     gyoryangLayer],
        ["btnFootbridge", yookgyoLayer],
        ["btnTunnel",     tunnelLayer],
        ["btnStruc",      mapoLayer],
        ["btnCheoldo",    cheoldoLayer],
      ];
      pairs.forEach(([id, layer]) => {
        layer.setVisible(true);
        document.getElementById(id)?.classList.add("active");
      });
    });

    // 전체 해제
    document.getElementById("btnAlldown")?.addEventListener("click", () => {
      const pairs = [
        ["btnBridge",     gyoryangLayer],
        ["btnFootbridge", yookgyoLayer],
        ["btnTunnel",     tunnelLayer],
        ["btnStruc",      mapoLayer],
        ["btnCheoldo",    cheoldoLayer],
      ];
      pairs.forEach(([id, layer]) => {
        layer.setVisible(false);
        document.getElementById(id)?.classList.remove("active");
      });
    });
	
    //전체 해제
    document.getElementById("btnAlldown")?.addEventListener("click", function() {
        gyoryangLayer.setVisible(false);
        yookgyoLayer.setVisible(false);
        tunnelLayer.setVisible(false);
        cheoldoLayer.setVisible(false);
        mapoLayer.setVisible(false);
        
        
      });
 // 데이터레일 접기/펼치기
    const toggleBtn = document.getElementById('toggleRailBtn');
    toggleBtn?.addEventListener('click', () => {
      document.body.classList.toggle('rail-collapsed');
      const collapsed = document.body.classList.contains('rail-collapsed');
      // 접근성/툴팁/아이콘 업데이트
      toggleBtn.setAttribute('aria-expanded', String(!collapsed));
      toggleBtn.title = collapsed ? '데이터레일 펼치기' : '데이터레일 접기';
      toggleBtn.textContent = collapsed ? '▶' : '◀';

      // 지도 크기 재계산 (애니메이션 끝난 뒤)
      setTimeout(() => map.updateSize(), 260);
    });

    // 창 크기 변경 시에도 안전하게 지도 사이즈 업데이트
    window.addEventListener('resize', () => {
      clearTimeout(window.__mapResizeTimer);
      window.__mapResizeTimer = setTimeout(() => map.updateSize(), 150);
    });
  </script>
</body>
</html>
