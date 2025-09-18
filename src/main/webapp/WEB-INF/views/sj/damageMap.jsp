<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>OpenLayers + GeoServer</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
<style>
:root {
	--header-h: 60px;
	--footer-h: 40px;
	--rail-w: 120px;
	--tool-w: 200px;
}
#dataRail {
	position: fixed;
	z-index: 900;
	top: var(--header-h, 60px);
	left: var(--rail-w);
	bottom: 0;
	width: var(--tool-w);
	background: #f3f3f3;
	border-right: 1px solid #ddd;
	padding: 12px 10px;
	display: flex;
	flex-direction: column;
	gap: 10px;
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
	left: calc(var(--rail-w)+ var(--tool-w));
	right: 0;
	bottom: var(--footer-h);
	z-index: 10;
	min-height: 300px;
	width: 100%;
	height: 100%;
}
#dataRail button {
	display: block;
	width: 100%;
	padding: 10px 12px;
	text-align: center;
	border-radius: 10px;
	border: 1px solid #6b7280;
	background: #fff;
	color: #111;
}
#dataRail button:hover {
	background: #e5e7eb;
}
body.rail-collapsed #dataRail {
	transform: translateX(-100%);
}
body.rail-collapsed #map {
	left: var(--rail-w);
}
.rail-toggle {
	position: fixed;
	z-index: 1200;
	top: 50%;
	transform: translateY(-50%);
	left: calc(var(--rail-w) + var(--tool-w) - 1px);  /* ✅ 레일 오른쪽 끝 */
	width: 18px;
	height: 80px;
	border: 1px solid #c9ccd1;
	background: #fff;
	cursor: pointer;
	user-select: none;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 14px;
	line-height: 1;
	transition: left .25s ease, background .15s ease, box-shadow .15s ease,
		transform .1s ease;
}
.rail-toggle:hover {
	background: #f6f7f9;
	box-shadow: 0 4px 8px rgba(0, 0, 0, .18);
}
.rail-toggle:active {
	transform: translateY(-50%) scale(.97);
}
body.rail-collapsed .rail-toggle {
  left: var(--rail-w);   /* ✅ 레일 닫히면 사이드바 바로 옆 */
}
#dataRail .btn.active {
	background: #e5e7eb;
}
/* 팝업 스타일 */
.ol-popup {
	position: absolute;
	background: white;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
	padding: 16px 12px 12px 12px;
	border-radius: 8px;
	border: 1px solid #cccccc;
	min-width: 200px;
	font-size: 14px;
	color: #111;
}
.popup-close {
	position: absolute;
	top: 6px;
	right: 6px;
	width: 22px;
	height: 22px;
	border: none;
	border-radius: 50%;
	background: #e02424;
	color: white;
	font-weight: bold;
	font-size: 14px;
	line-height: 20px;
	text-align: center;
	cursor: pointer;
	transition: background 0.2s ease;
}
.popup-close:hover {
	background: #b91c1c;
}
</style>
</head>
<body>
			
	<!-- 지도 버튼 -->
	<div id="mapButtons">
	  <button id="btnA" class="map-btn">범례</button>
	  <button id="btnB" class="map-btn">지도 초기화</button>
	
	  <!-- 범례 말풍선 -->
	  <div id="legendPopup" class="balloon">
	    <div class="popup-header">
	      <h4>범례</h4>
	      <button id="closeLegend" class="close-btn">×</button>
	    </div>
	    <ul class="legend">
	      <li><span class="legend-color red"></span> 교량</li>
	      <li><span class="legend-color black"></span> 터널</li>
	      <li><span class="legend-color blue"></span> 하천</li>
	      <li><span class="legend-color orange"></span> 상하수도</li>
	      <li><span class="legend-color gray"></span> 옹벽</li>
	      <li><span class="legend-color brown"></span> 질토사면</li>
	      <li><span class="legend-color green"></span> 건축물</li>
	      <li><span class="legend-color yellow"></span> 즐겨찾기</li>
	    </ul>
	  </div>
	</div>

		<style>
		#mapButtons {
		  position: absolute;
		  top: 80px;
		  right: 20px;
		  display: flex;
		  flex-direction: column;
		  gap: 10px;
		  z-index: 2000;
		}
		
		
		.map-btn {
		  background: #fff;
		  border: 1px solid #ccc;
		  border-radius: 6px;
		  padding: 6px 12px;
		  font-size: 14px;
		  cursor: pointer;
		  box-shadow: 0 2px 5px rgba(0,0,0,0.2);
		}
		.map-btn:hover {
		  background: #f0f0f0;
		}
		
		/* 말풍선 */
		.balloon {
		  position: absolute;
		  top: 0;
		  left: -185px; /* 버튼 기준 왼쪽으로 배치 */
		  background: #fff;
		  border: 1px solid #ccc;
		  border-radius: 8px;
		  padding: 10px 15px;
		  box-shadow: 0 3px 8px rgba(0,0,0,0.3);
		  display: none;
		  min-width: 180px;
		  z-index: 2100;
		}
		
		/* 말풍선 꼬리 */
		.balloon::after {
		  content: "";
		  position: absolute;
		  top: 15px;
		  right: -10px; /* 오른쪽 방향 꼬리 */
		  border-width: 10px;
		  border-style: solid;
		  border-color: transparent transparent transparent #fff;
		  filter: drop-shadow(1px 0 1px rgba(0,0,0,0.2));
		}
		
		.popup-header {
		  display: flex;
		  justify-content: space-between;
		  align-items: center;
		  margin-bottom: 8px;
		}
		
		.balloon h4 {
		  margin: 0 0 2px 0;
		  font-size: 14px; 
		}
		.close-btn {
		  background: none;
		  border: none;
		  font-size: 12px;   /* 작게 */
		  font-weight: normal;
		  cursor: pointer;
		  line-height: 1;
		  padding: 0;        /* 최소화 */
		  color: #555;       /* 연한 회색 */
		  transition: color 0.2s;
		}
		.close-btn:hover {
  color: #000;       /* 마우스 올리면 진하게 */
}
		.balloon ul {
		  padding: 0;
		  margin: 0;
		  list-style: none;
		  font-size: 13px;
		}
		.balloon li {
		  margin-bottom: 4px;
		  display: flex;
		  align-items: center;
		  gap: 6px;
		}
		
		/* 범례 색상 박스 */
		.legend-color {
		  display: inline-block;
		  width: 14px;
		  height: 14px;
		  border-radius: 50%;
		  border: 1px solid #999;
		}
		.red { background: red; }
		.black { background: black; }
		.blue { background: blue; }
		.orange { background: orange; }
		.gray { background: gray; }
		.brown { background: saddlebrown; }
		.green { background: green; }
		.yellow { background: yellow; }
		</style>

<script>
		//통계보기
		const legendPopup = document.getElementById("legendPopup");
		const closeBtn = document.getElementById("closeLegend");
		const btnA = document.getElementById("btnA");
		// 범례 버튼 클릭 시 토글
		btnA.addEventListener("click", () => {
		  const isVisible = legendPopup.style.display === "block";
		  legendPopup.style.display = isVisible ? "none" : "block";
		});
		
		// X 버튼 클릭 시 닫기
		closeBtn.addEventListener("click", () => {
		  legendPopup.style.display = "none";
		});
		
		const btnB = document.getElementById("btnB");
		btnB.addEventListener("click", () => {
		  map.getView().animate({
		    center: ol.proj.fromLonLat([127.024612, 37.5326]),
		    zoom: 12,
		    duration: 800
		  });
		});

</script>


	<!-- 메뉴 -->
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<jsp:include page="/WEB-INF/views/sidebar.jsp" />
	<aside id="dataRail">
		<!-- 지역 선택 -->
		<div style="text-align: center; margin-bottom: 12px;">
			<label class="form-label text-black">지역 선택</label>
			<div style="margin-top: 6px;">
				<select id="region1" class="form-select form-select-sm">
					<option>서울특별시</option>
				</select> <select id="region2" class="form-select form-select-sm">
					<option>전체</option>
					<option>은평구</option>
					<option>서대문구</option>
					<option>종로구</option>
					<option>마포구</option>
					<option>영등포구</option>
					<option>서초구</option>
					<option>강남구</option>
					<option>구로구</option>
					<option>금천구</option>
				</select> 
			</div>
		</div>
		<!-- 사회기반시설 선택 -->
		<div style="text-align: center;">
			<label class="form-label text-black">사회기반시설 선택</label>
			<div class="d-grid gap-2">
				<button id="btnGyoryang" class="btn btn-light btn-sm">교량</button>
				<button id="btnTunnel" class="btn btn-light btn-sm">터널</button>
				<button id="btnRiver" class="btn btn-light btn-sm">하천</button>
				<button id="btnSudo" class="btn btn-light btn-sm">상하수도</button>
				<button id="btnWall" class="btn btn-light btn-sm">옹벽</button>
				<button id="btnSamyun" class="btn btn-light btn-sm">절토사면</button>
				<button id="btnBuilding" class="btn btn-light btn-sm">건축물</button>
				<button id="btnALLON" class="btn btn-light btn-sm">전체</button>
				<button id="btnALLOFF" class="btn btn-light btn-sm">전체 해제</button>
			</div>
		</div>
		
		<!-- ✅ 즐겨찾기 토글 -->
		<div
			style="margin-top: auto; text-align: center; padding-top: 12px; border-top: 1px solid #ddd;">
			<button id="btnFavoriteToggle" class="btn btn-light btn-sm"
				style="width: 100%;">⭐ 즐겨찾기</button>
			<!-- 즐겨찾기 리스트 -->
			<div id="favoriteList"
				style="margin-top: 8px; max-height: 200px; overflow-y: auto; text-align: left; display: none; border: 1px solid #ddd; border-radius: 6px; background: #fff; padding: 6px; font-size: 14px;">
			</div>
		</div>
	</aside>
	<button id="toggleRailBtn" class="rail-toggle" aria-expanded="true"
		title="데이터레일 접기">◀</button>
	<div id="map"></div>
	
	<script>
    // ✅ 배경지도 (VWorld)
    const vworldLayer = new ol.layer.Tile({
      source: new ol.source.XYZ({
         url: "http://api.vworld.kr/req/wmts/1.0.0/60DA3367-BC75-32D9-B593-D0386112A70C/Base/{z}/{y}/{x}.png"
      })
    });
    // ✅ 지도 생성 (EPSG:3857)	
    const map = new ol.Map({
      target: "map",
      layers: [vworldLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]), // 서울 중심
        zoom: 12
      })
    });
  </script>
	<!-- ✅ 시설별 레이어 정의 JSP include -->
	<jsp:include page="/WEB-INF/views/sj/layers/gyoryang.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/tunnel.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/river.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/sudo.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/wall.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/samyun.jsp" />
	<jsp:include page="/WEB-INF/views/sj/layers/building.jsp" />
	<jsp:include page="/WEB-INF/views/sh/hoshiLayer.jsp" />
	<script>
    // ✅ 레일 토글 버튼 동작
    const toggleBtn = document.getElementById("toggleRailBtn");
    toggleBtn.addEventListener("click", () => {
      document.body.classList.toggle("rail-collapsed");
      if (document.body.classList.contains("rail-collapsed")) {
        toggleBtn.textContent = "▶";
        toggleBtn.setAttribute("title", "데이터레일 열기");
        toggleBtn.setAttribute("aria-expanded", "false");
      } else {
        toggleBtn.textContent = "◀";
        toggleBtn.setAttribute("title", "데이터레일 접기");
        toggleBtn.setAttribute("aria-expanded", "true");
      }
    });
	     
	// ✅ 우클릭용 팝업 + 닫기 버튼
	const coordPopupContainer = document.createElement('div');
	coordPopupContainer.className = 'ol-popup';
	coordPopupContainer.innerHTML = `
	  <button class="popup-close">×</button>
	  <div id="coord-popup-content"></div>
	`;
	document.body.appendChild(coordPopupContainer);
	
	const coordPopupContent = coordPopupContainer.querySelector('#coord-popup-content');
	const coordCloseBtn = coordPopupContainer.querySelector('.popup-close');
	
	const coordPopupOverlay = new ol.Overlay({
	  element: coordPopupContainer,
	  positioning: 'bottom-center',
	  stopEvent: true
	});
	map.addOverlay(coordPopupOverlay);
	
	// 닫기 버튼 → 우클릭 팝업만 닫기
	coordCloseBtn.addEventListener('click', () => {
	  coordPopupOverlay.setPosition(undefined);
	});
	
	// ✅ 좌클릭용 팝업 + 즐겨찾기
	const infoPopupContainer = document.createElement('div');
	infoPopupContainer.className = 'ol-popup';
	
	// ✨ 즐겨찾기 버튼 추가 (우상단)
	infoPopupContainer.innerHTML = `
	  <div style="position:relative;">
	    <div id="info-popup-content"></div>
	  </div>
	`;
	document.body.appendChild(infoPopupContainer);
	
	const infoPopupContent = infoPopupContainer.querySelector('#info-popup-content');
	const infoPopupOverlay = new ol.Overlay({
	  element: infoPopupContainer,
	  positioning: 'bottom-center',
	  stopEvent: true,
	  offset: [0, -320]
	});
	map.addOverlay(infoPopupOverlay);
	
	// ✅ 모든 벡터 레이어 공통 팝업 (좌클릭)
	map.on("singleclick", function(evt) {
	  let found = false;
	  map.forEachFeatureAtPixel(evt.pixel, function(feature, layer) {
	    if (!feature || !feature.getGeometry()) return;
	    let center;
	    if (feature.getGeometry().getType() === "Point") {
	      center = feature.getGeometry().getCoordinates();
	    } else {
	      const extent = feature.getGeometry().getExtent();
	      center = ol.extent.getCenter(extent);
	    }
	    map.getView().animate({
	      center: center,
	      zoom: 16,
	      duration: 800
	    });
	    const props   = feature.getProperties();
	    const name    = props.name    || "(이름 없음)";
	    const address = props.address || "(주소 없음)";
	    const managecode = props.managecode;
	    // ✅ 팝업 열기
	    infoPopupOverlay.setPosition(center);
	    // ✅ 팝업 내용 채우기 (이름 + 즐겨찾기 아이콘 한 줄)
	    infoPopupContent.innerHTML =
	      '<div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:8px;">' +
	        '<div style="font-size:15px;"><b>이름:</b> ' + name + '</div>' +
	        '<button id="favToggleBtn" style="border:none; background:none; cursor:pointer; line-height:1;">' +
	          '<i class="bi bi-bookmark" style="font-size:30px; color:gray;"></i>' +
	        '</button>' +
	      '</div>' +
	      '<div style="margin-bottom:8px;"><b>소재지:</b> ' + address + '</div>' +
	      '<div id="inspBox" style="margin-top:8px; font-size:0.9em; color:#555;">안전진단표 불러오는 중...</div>' +
	      '<div style="margin-top:6px; display:flex; gap:6px;">' +
	      // ✅ 통계보기 버튼 → 관리코드 전달
	      '<button class="btn btn-sm btn-primary" onclick="openStatsPanel(' + managecode + ')">통계보기</button>' +
	      '<a href="javascript:void(0);" ' +
	      '   class="btn btn-sm btn-secondary" ' +
	      '   onclick="window.open(\'' + '${pageContext.request.contextPath}/inspectList?managecode=' + managecode + '\', ' +
	      '   \'inspectWin\', \'width=1000,height=600,scrollbars=yes,resizable=yes\');">점검 내역</a>' +
	    '</div>';
	    found = true;
	    // ✅ 즐겨찾기 버튼 가져오기
	    const favBtn = document.getElementById("favToggleBtn");
	    if (managecode) {
	      // 현재 즐겨찾기 여부 조회
	      fetch("${pageContext.request.contextPath}/api/damage/hoshi/status?managecode=" + managecode)
	        .then(r => r.json())
	        .then(data => {
	          favBtn.innerHTML = (data.hoshi === 1)
	            ? '<i class="bi bi-bookmark-star-fill" style="font-size:30px; color:gold;"></i>'
	            : '<i class="bi bi-bookmark" style="font-size:30px; color:gray;"></i>';
	          loadFavoriteList();
	        })
	        .catch(err => console.error("즐겨찾기 상태 조회 실패:", err));
	      // 클릭 시 즐겨찾기 토글
	      favBtn.onclick = function() {
	        fetch("${pageContext.request.contextPath}/api/damage/hoshi/toggle", {
	          method: "POST",
	          headers: { "Content-Type": "application/json" },
	          body: JSON.stringify({ managecode: managecode })
	        })
	        .then(r => r.json())
	        .then(data => {
	          favBtn.innerHTML = data.hoshi
	            ? '<i class="bi bi-bookmark-star-fill" style="font-size:30px; color:gold;"></i>'
	            : '<i class="bi bi-bookmark" style="font-size:30px; color:gray;"></i>';
	          loadFavoriteList();
	          
	       	  // ✅ hoshiLayer 소스 갱신
	          if (window.hoshiLayer) {
	            window.hoshiLayer.getSource().clear();      // 기존 캐시 제거
	            window.hoshiLayer.getSource().refresh();    // 서버에서 다시 가져오기
	          }
	        })
	        .catch(err => console.error("즐겨찾기 업데이트 실패:", err));
	      };
	    }
	    // ✅ 진단표 fetch (기존 코드 그대로)
	    if (managecode) {
	      fetch("${pageContext.request.contextPath}/api/damage/" + managecode + "/inspection")
	        .then(r => r.json())
	        .then(data => {
	          const inspBox = document.getElementById("inspBox");
	          if (!data || data.error || data.status >= 400) {
	            inspBox.innerHTML = "<div style='color:red;'>점검표 불러오기 실패</div>";
	            // 표가 없으니 offset 0
	            infoPopupOverlay.setOffset([0, 0]);
	            return;
	          }
	          if (Object.keys(data).length === 0) {
	            inspBox.innerHTML = "<div>점검 이력 없음</div>";
	          } else {
	            let html = '<table class="table table-sm table-bordered mb-0">';
	            html += "<thead><tr><th>손상유형</th><th>손상 위험도</th></tr></thead><tbody>";
	            for (const key in data) {
	              if (Object.prototype.hasOwnProperty.call(data, key)) {
	                const value = data[key];
	                html += "<tr><td>" + key + "</td><td>" + (value ? value : '-') + "</td></tr>";
	              }
	            }
	            html += "</tbody></table>";
	            inspBox.innerHTML = html;
	          }
	          infoPopupOverlay.setOffset([0, -320]);
	        })
	        .catch(err => {
	          console.error("점검표 로드 오류:", err);
	          const insp = document.getElementById("inspBox");
	          if (insp) insp.innerHTML = "<div style='color:red;'>점검표 불러오기 실패</div>";
	        });
	    }
	  });
	  
	  if (!found) {
	    infoPopupOverlay.setPosition(undefined);
	  }
	});
	
	
	// ✅ 우클릭 이벤트 → 좌표 표시, 건물 등록
	map.on("contextmenu", function(evt) {
	  evt.preventDefault();
	  // OpenLayers에서 제공하는 픽셀 → 좌표 변환
	  const coord = map.getCoordinateFromPixel(evt.pixel);
	  const x = coord[0];
	  const y = coord[1];
	  // 우클릭 팝업을 정확히 클릭 지점에 표시
	  coordPopupOverlay.setPosition(coord);
	  const btnId = "registerButton_" + Date.now();
	  coordPopupContent.innerHTML =
	    "<b>좌표</b><br/>" +
	    "X: " + x.toFixed(2) + "<br/>" +
	    "Y: " + y.toFixed(2) + "<br/>" +
	    '<div style="margin-top:6px; display:flex; gap:6px;">' +
	      '<button id="' + btnId + '" class="btn btn-sm btn-primary">건물 등록</button>' +
	    '</div>';
	  // 좌클릭 팝업 닫기
	  infoPopupOverlay.setPosition(undefined);
	  // 버튼 이벤트
	  const btn = document.getElementById(btnId);
	  if (btn) {
	    btn.addEventListener("click", () => {
	      const url = "${pageContext.request.contextPath}/sj/registerPage"
	        + "?x=" + x.toFixed(2)
	        + "&y=" + y.toFixed(2);
	      window.open(url, "_blank", "width=800,height=550");
	    });
	  }
	});
    // ✅ 각 구 중심 좌표 (EPSG:4326 → 변환해서 EPSG:3857 사용)
   const regionCenters = {
     "전체": [127.024612, 37.5326], // 서울 중심
     "마포구": [126.9018, 37.5662],
     "서대문구": [126.9386, 37.5791],
     "종로구": [126.9865, 37.5825],
     "은평구": [126.9270, 37.6017],
     "영등포구": [126.9139242, 37.520641],  
     "서초구":   [127.0378103, 37.4769528],
     "강남구":   [127.0664091, 37.4959854], 
     "구로구":   [126.8581210, 37.4954856], 
     "금천구":   [126.9001546, 37.4600969] 
   };
    
    // ✅ 전체 켜기 버튼
   document.getElementById("btnALLON").addEventListener("click", () => {
     const layers = [gyoryangLayer, tunnelLayer, riverLayer, sudoLayer, wallLayer, samyunLayer, buildingLayer];
     const buttons = ["btnGyoryang","btnTunnel","btnRiver","btnSudo","btnWall","btnSamyun","btnBuilding"];
     layers.forEach(layer => layer && layer.setVisible(true));
     buttons.forEach(id => document.getElementById(id)?.classList.add("active"));
   });
	// ✅ 전체 해제 버튼
   document.getElementById("btnALLOFF").addEventListener("click", () => {
     const layers = [gyoryangLayer, tunnelLayer, riverLayer, sudoLayer, wallLayer, samyunLayer, buildingLayer];
     const buttons = ["btnGyoryang","btnTunnel","btnRiver","btnSudo","btnWall","btnSamyun","btnBuilding"];
     layers.forEach(layer => layer && layer.setVisible(false));
     buttons.forEach(id => document.getElementById(id)?.classList.remove("active"));
   });
    // ✅ 지역 선택 이벤트
    document.getElementById("region2").addEventListener("change", function () {
      const selected = this.value;
      if (regionCenters[selected]) {
        const view = map.getView();
        const center = ol.proj.fromLonLat(regionCenters[selected]);
        
        let zoomLevel = 14;   // 기본 줌
        if (selected === "전체") {
          zoomLevel = 13;     // 전체일 때만 줌 다르게
        }

        view.animate({
          center: center,
          zoom: zoomLevel,   // ✅ 변수 적용
          duration: 800
        });

      }
    });
    
 	// ✅ 즐겨찾기 토글 버튼
    const favBtn = document.getElementById("btnFavoriteToggle");
    const favList = document.getElementById("favoriteList");
    favBtn.addEventListener("click", () => {
      favBtn.classList.toggle("active");
      if (favBtn.classList.contains("active")) {
        favBtn.innerHTML = "⭐ 즐겨찾기";
        favList.style.display = "block";   // 리스트 보여주기
        
        document.getElementById("btnALLOFF").click();
        
        if (window.hoshiLayer) {
            window.hoshiLayer.setVisible(true);   // ✅ hoshiLayer 켜기
          }
        
        
        // AJAX 호출 (예: /api/favorites)
        fetch("${pageContext.request.contextPath}/api/damage/hoshi")
        .then(r => r.json())
        .then(data => {
          if (!data || data.length === 0) {
            favList.innerHTML = "<div style='color:#888;'>즐겨찾기 없음</div>";
            return;
          }
          let html = "<ul style='list-style:none; margin:0; padding:0;'>";
          data.forEach(item => {
            html +=
              '<li data-x="' + item.x + '" data-y="' + item.y + '"' +
              ' style="padding:4px 2px; border-bottom:1px solid #eee; cursor:pointer;">' +
              '🔖 ' + item.name +
              '</li>';
          });
          html += "</ul>";
          favList.innerHTML = html;
          // ✅ 리스트 클릭 이벤트 → 지도 이동
          favList.querySelectorAll("li").forEach(li => {
            li.addEventListener("click", function() {
              const x = parseFloat(this.getAttribute("data-x"));
              const y = parseFloat(this.getAttribute("data-y"));
              const coord = [x, y]; // EPSG:3857
              map.getView().animate({
                center: coord,
                zoom: 16,
                duration: 800
              });
            });
          });
        })
        .catch(err => {
          console.error("즐겨찾기 로드 오류:", err);
          favList.innerHTML = "<div style='color:red;'>불러오기 실패</div>";
        });
      } else {
    	    favBtn.innerHTML = "☆ 즐겨찾기";
    	    favList.style.display = "none";   // 리스트 숨기기
    	    if (window.hoshiLayer) {
    	        window.hoshiLayer.setVisible(false);  // ✅ hoshiLayer 끄기
    	    }
      }
   });
 	// ✅ 맵 바깥쪽 클릭 시 팝업 닫기
    map.on("singleclick", function(evt) {
      const feature = map.forEachFeatureAtPixel(evt.pixel, function(feature) {
        return feature;
      });
      if (!feature) {
        infoPopupOverlay.setPosition(undefined);   // 좌클릭 팝업 닫기
        coordPopupOverlay.setPosition(undefined);  // 우클릭 팝업 닫기
        document.getElementById("statsPanel").style.display = "none"; // 통계 패널 닫기
      }
    });
    // ✅ 맵 아무데나 우클릭하면 기존 좌표 팝업 닫기
    map.on("pointerdown", function(evt) {
      if (evt.originalEvent.button === 2) { // 우클릭
        coordPopupOverlay.setPosition(undefined);
        document.getElementById("statsPanel").style.display = "none"; // 통계 패널 닫기
      }
    });
    
    function loadFavoriteList() {
    	  const favList = document.getElementById("favoriteList");
    	  fetch("${pageContext.request.contextPath}/api/damage/hoshi")
    	    .then(r => r.json())
    	    .then(data => {
    	      if (!data || data.length === 0) {
    	        favList.innerHTML = "<div style='color:#888;'>즐겨찾기 없음</div>";
    	        return;
    	      }
    	      let html = "<ul style='list-style:none; margin:0; padding:0;'>";
    	      data.forEach(item => {
    	        html +=
    	          '<li data-x="' + item.x + '" data-y="' + item.y + '"' +
    	          ' style="padding:4px 2px; border-bottom:1px solid #eee; cursor:pointer;">' +
    	          '🔖 ' + item.name +
    	          '</li>';
    	      });
    	      html += "</ul>";
    	      favList.innerHTML = html;
    	      // ✅ 리스트 클릭 이벤트 → 지도 이동
    	      favList.querySelectorAll("li").forEach(li => {
    	        li.addEventListener("click", function() {
    	          const x = parseFloat(this.getAttribute("data-x"));
    	          const y = parseFloat(this.getAttribute("data-y"));
    	          map.getView().animate({
    	            center: [x, y],
    	            zoom: 16,
    	            duration: 800
    	          });
    	        });
    	      });
    	    })
    	    .catch(err => {
    	      console.error("즐겨찾기 로드 오류:", err);
    	      favList.innerHTML = "<div style='color:red;'>불러오기 실패</div>";
    	    });
    	}
  </script>
  
	<!-- ✅ 통계 패널 -->
	<div id="statsPanel">
	  <div class="stats-header">
	    <span>📊 통계 결과</span>
	    <button id="closeStats">×</button>
	  </div>
	  <div style="padding: 10px; text-align:center; color:#666;">
	    <iframe id="analysisFrame" src="" style="width:100%; height:180px; border:none;"></iframe>
	  </div>
	</div>

<style>
  #statsPanel {
    position: fixed;
    right: 0;
    bottom: 0;
    height: 220px;
    background: #fff;
    border-top: 2px solid #444;
    box-shadow: 0 -2px 6px rgba(0,0,0,0.2);
    display: none;   /* ✅ 처음엔 숨김 */
    z-index: 2000;
    transition: left .25s ease, height .3s ease;
  }
  #statsPanel .stats-header {
    display: flex; justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    font-weight: bold;
    background: #f5f5f5;
    border-bottom: 1px solid #ddd;
  }
  #statsPanel button {
    border:none; background:transparent;
    font-size: 18px; cursor:pointer;
  }
  
    .map-btn:disabled {
	  background: #eee;
	  color: #999;
	  cursor: not-allowed;
	  box-shadow: none;
	  }
</style>

<script>
  const statsPanel = document.getElementById("statsPanel");  
  const statsClose = document.getElementById("closeStats");

  // ✅ 현재 left 계산해서 적용
  function updateStatsPanelLeft() {
    if (!statsPanel) return;
    if (document.body.classList.contains("rail-collapsed")) {
      // 레일 접힌 상태 → dataRail 만큼만 띄움
      statsPanel.style.left = getComputedStyle(document.documentElement)
                              .getPropertyValue("--rail-w");
    } else {
      // 레일 펼친 상태 → dataRail + toolRail 만큼 띄움
      statsPanel.style.left = `calc(var(--rail-w) + var(--tool-w))`;
    }
  }

  // ✅ 초기 위치 세팅
  updateStatsPanelLeft();

  // ✅ 레일 토글될 때도 위치 업데이트
  document.getElementById("toggleRailBtn").addEventListener("click", () => {
    setTimeout(updateStatsPanelLeft, 260); // transition 끝난 뒤 적용
  });

  // ✅ 윈도우 리사이즈 시에도 보정
  window.addEventListener("resize", updateStatsPanelLeft);

  
  // ✅ 닫기 버튼
  statsClose.addEventListener("click", () => {
    statsPanel.style.display = "none";
  });
  
  function openStatsPanel(managecode) {
	  const statsPanel = document.getElementById("statsPanel");
	  statsPanel.style.display = "block";

	  // ✅ 이제는 /analysis/view 로 접근해야 함
	  const iframe = document.getElementById("analysisFrame");
	  iframe.src = "${pageContext.request.contextPath}/analysis/view?managecode=" + managecode;
	}


</script>
  	
  
</body>
</html>