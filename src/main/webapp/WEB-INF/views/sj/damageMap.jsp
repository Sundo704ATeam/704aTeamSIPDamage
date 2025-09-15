<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>OpenLayers + GeoServer</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
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

    /* 팝업 스타일 */
    .ol-popup {
      position: absolute;
      background: white;
      box-shadow: 0 2px 8px rgba(0,0,0,0.3);
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
    .popup-close:hover { background: #b91c1c; }
  </style>
</head>
<body>
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
       </select>
      <select id="region2" class="form-select form-select-sm">
        <option>전체</option>
        <option>은평구</option>
        <option>서대문구</option>
        <option>종로구</option>
        <option>마포구</option>
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
  </aside>

  <button id="toggleRailBtn" class="rail-toggle" aria-expanded="true" title="데이터레일 접기">◀</button>
  <div id="map"></div>
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

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

    // ✅ 팝업 컨테이너 + 닫기 버튼
    const popupContainer = document.createElement('div');
    popupContainer.className = 'ol-popup';
    popupContainer.innerHTML = `
      <button class="popup-close">×</button>
      <div id="popup-content"></div>
    `;
    document.body.appendChild(popupContainer);

    const popupContent = popupContainer.querySelector('#popup-content');
    const closeBtn = popupContainer.querySelector('.popup-close');

    const popupOverlay = new ol.Overlay({
      element: popupContainer,
      positioning: 'bottom-center',
      stopEvent: true,
      offset: [0, -10]
    });
    map.addOverlay(popupOverlay);

    // 닫기 버튼 → 팝업 숨김
    closeBtn.addEventListener('click', () => {
      popupOverlay.setPosition(undefined);
    });
    

 // ✅ 모든 벡터 레이어 공통 팝업
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

    const props = feature.getProperties();
    const name = props.name || "(이름 없음)";
    const type = props.type || "(정보 없음)";
    const sort = props.sort || "(정보 없음)";
    const address = props.address || "(주소 없음)";

    popupOverlay.setPosition(center);
    popupContent.innerHTML =
      "<b>이름:</b> " + name + "<br>" +
      "<b>종류:</b> " + type + "<br>" +
      "<b>종별:</b> " + sort + "<br>" +
      "<b>소재지:</b> " + address +
      "<div id='inspBox' style='margin-top:8px; font-size:0.9em; color:#555;'>안전진단표 불러오는 중...</div>" +
      "<div style='margin-top:6px; display:flex; gap:6px;'>" +
        "<button id='btnInspect' class='btn btn-sm btn-primary'>점검 하기</button>" +
        "<button id='btnHistory' class='btn btn-sm btn-secondary'>점검 내역</button>" +
      "</div>";

    console.log("클릭된 feature:", props);
    found = true;

    var managecode = props.managecode;
    console.log("선택된 관리번호:", managecode);

    if (managecode) {
      fetch("${pageContext.request.contextPath}/api/damage/" + managecode + "/inspection")
        .then(r => r.json())
        .then(map => {
          var inspBox = document.getElementById("inspBox");
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
                html += "<tr><td>" + key + "</td><td>" + (value ? value : '-') + "</td></tr>";
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

  
  if (!found) {
    popupOverlay.setPosition(undefined);
  }
});
 // 우클릭 이벤트 → 좌표 표시, 건물 등록
    map.on("contextmenu", function(evt) {
      evt.preventDefault();

      // EPSG:3857 좌표 그대로 사용 (DB 저장용)
      const coord = evt.coordinate; 
      const x = coord[0];
      const y = coord[1];

      popupOverlay.setPosition(coord);

      // 버튼마다 고유한 ID 생성
      const btnId = "registerButton_" + Date.now();

      // 화면에는 보기 좋게 소수점 2자리만
      popupContent.innerHTML =
        "<b>좌표</b><br/>" +
        "X: " + x.toFixed(2) + "<br/>" +
        "Y: " + y.toFixed(2) + "<br/>" +
        '<div style="margin-top:6px; display:flex; gap:6px;">' +
          '<button id="' + btnId + '" class="btn btn-sm btn-primary">건물 등록</button>' +
        '</div>';

      // innerHTML로 버튼이 만들어진 직후 이벤트 연결
      const btn = document.getElementById(btnId);
      if (btn) {
        btn.addEventListener("click", () => {
          // URL 파라미터에는 double 원본값 그대로 넘김
          const url = "${pageContext.request.contextPath}/sj/registerPage"
        	  + "?x=" + x.toFixed(2) 
              + "&y=" + y.toFixed(2);
          window.open(url, "_blank", "width=600,height=400");
        });
      }
    });

    // ✅ 각 구 중심 좌표 (EPSG:4326 → 변환해서 EPSG:3857 사용)
   const regionCenters = {
     "전체": [127.024612, 37.5326], // 서울 중심
     "마포구": [126.9104, 37.5663],
     "서대문구": [126.9386, 37.5791],
     "종로구": [126.9794, 37.5720],
     "은평구": [126.9271, 37.6027],
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
        view.animate({
          center: center,
          zoom: 14,
          duration: 800
        });
      }
    });
  </script>
</body>
</html>
