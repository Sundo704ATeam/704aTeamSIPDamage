<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>실시간 미세먼지</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
  <script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
  <style>
    :root {
      --header-h: 60px;
      --footer-h: 40px;
      --rail-w: 60px;
      --tool-w: 120px;

      /* 🔧 여기 값으로 +/− 버튼을 바 기준 왼쪽/오른쪽 미세조정 */
      --zoom-x: -16px;  /* 음수면 왼쪽, 양수면 오른쪽 */
      --zoom-gap: 16px; /* 버튼과 바 사이 세로 간격 */
      --legend-bottom: 100px; /* 범례 묶음의 화면 하단에서의 오프셋 */
    }

    html, body { margin:0; height:100%; }

    /* ===== 지도 ===== */
    #map {
      width: 100%;
      height: calc(100vh - var(--footer-h, 40px)); /* footer 공간 제외 */
    }

    /* ===== 좌측 추가 데이터 레일 ===== */
    #dataRail {
      position: fixed; z-index: 900;
      top: var(--header-h, 60px);
      left: var(--rail-w, 60px);
      bottom: var(--footer-h, 40px);
      width: var(--tool-w, 120px);
      background:#f3f3f3;
      border-right:1px solid #ddd;
      padding:12px 10px;
      display:flex;
      flex-direction:column;
      gap:8px;
    }
    #dataRail a, #dataRail button.rail-link {
      display:block;
      width:100%;
      padding:10px 12px;
      text-align:left;
      border-radius:10px;
      border:1px solid #6b7280;
      background:#fff;
      color:#111;
      cursor:pointer;
    }
    #dataRail a:hover, #dataRail button.rail-link:hover { background:#e5e7eb; }
    #dataRail .caret {
      width:0; height:0; margin-left:8px;
      border-left:5px solid transparent;
      border-right:5px solid transparent;
      border-top:6px solid #4b5563;
      transition: transform .2s ease;
    }
    #dataRail .rail-link[aria-expanded="true"] .caret { transform: rotate(180deg); }
    #dataRail .submenu { overflow:hidden; max-height:0; transition:max-height .2s ease; }
    #dataRail .submenu.open { margin-top:4px; }
    #dataRail .sub-link {
      display:block; padding:8px 10px; margin:4px 0 0 6px; font-size:13px;
      border-radius:8px; border:1px dashed #cbd5e1; background:#fff; color:#111; text-decoration:none;
    }
    #dataRail .sub-link:hover { background:#f3f4f6; }

    /* ===== 우측 하단 범례(+/−, 바, 숫자) ===== */
    #legendContainer {
      position: fixed;
      right: 20px;
      bottom: var(--legend-bottom);
      display: flex;
      flex-direction: column;   /* 위: 버튼, 아래: 바+숫자 */
      align-items: center;      /* 같은 세로축에 일직선 */
      gap: var(--zoom-gap);
      z-index: 2000;
    }
    #zoomControls {
      display: flex;
      flex-direction: column;
      gap: 2px;
      /* 버튼 묶음을 바 기준으로 좌/우 이동 */
      position: relative;
      left: var(--zoom-x);
    }
    #zoomControls button {
      width: 30px; height: 30px;
      border: 1px solid #ccc; background: #fff; cursor: pointer;
      border-radius: 4px; font-size: 16px; font-weight: bold;
    }
    #legendRow {
      display: flex;
      flex-direction: row;   /* 바 + 숫자 나란히 */
      align-items: center;
      gap: 6px;
      margin-top: 6px;
    }
    #legendBar {
	  width: 30px;
	  height: 220px;
	  background: linear-gradient(to top,
	    #00B050 0%,    /* 맨 아래: 0 (좋음) */
	    #FFFF00 40%,   /* 중간: 80 */
	    #FF9900 70%,   /* 위쪽: 150 */
	    #FF0000 100%   /* 맨 위: 200+ (매우 나쁨) */
	  );
	  border: 1px solid #ccc;
	  border-radius: 6px;
	  box-shadow: 0 2px 6px rgba(0,0,0,0.15);
	}

    #legendLabels {
      display: flex; flex-direction: column; justify-content: space-between;
      height: 220px; font-size: 11px; color: #000;
    }

    /* ===== 팝업 ===== */
    .ol-popup {
      position: absolute; background: #fff; border: 1px solid #ccc;
      padding: 10px 14px; min-width: 260px; font-size: 13px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.3); border-radius: 6px;
    }
    .popup-closer {
      position: absolute; top: 4px; right: 8px; text-decoration: none; color: #aaa; font-weight: bold;
    }
    .popup-closer:hover { color:#000; }

    /* ===== 측정소 갱신 버튼 ===== */
    #refreshBtn {
      position: fixed; top: 80px; right: 20px; z-index: 2000;
      padding: 8px 12px; font-size: 13px; border: 1px solid #ccc; border-radius: 6px; background: #fff; cursor: pointer;
    }

    /* ===== Footer ===== */
    footer {
      position: fixed; bottom: 0; left: 0; right: 0; height: var(--footer-h, 40px);
      background: #1f2937; color: #fff; display: flex; align-items: center; justify-content: center;
      font-size: 13px; z-index: 2100;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <!-- 좌측 추가 데이터 레일 -->
  <aside id="dataRail" role="navigation" aria-label="보조 메뉴">
    <a class="rail-link" href="${pageContext.request.contextPath}/rain">강우량</a>
    <button type="button" class="rail-link" id="dustToggle" aria-expanded="false" aria-controls="dustSub">
      황사 <span class="caret" aria-hidden="true"></span>
    </button>
    <div id="dustSub" class="submenu" role="region" aria-label="황사 하위 메뉴">
      <a class="sub-link" href="${pageContext.request.contextPath}/dust">실시간 PM10 측정정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dust24">PM10 예측정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest">측정소 3개월 타임라인</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest2">측정소 1개월 타임라인+실시간</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/realDust">진짜 실시간+2주 타임라인</a>
    </div>
  </aside>

  <div id="map"></div>

  <!-- 측정소 갱신 버튼 -->
  <button id="refreshBtn">측정소 갱신</button>

  <!-- 우측 범례/줌 -->
  <div id="legendContainer">
    <div id="zoomControls">
      <button id="zoomIn">+</button>
      <button id="zoomOut">−</button>
    </div>
    <div id="legendRow">
      <div id="legendBar"></div>
      <div id="legendLabels">
        <span>200+</span>
        <span>150</span>
        <span>80</span>
        <span>30</span>
        <span>0</span>
      </div>
    </div>
  </div>

  <!-- 팝업 -->
  <div id="popup" class="ol-popup">
    <a href="#" id="popup-closer" class="popup-closer">✖</a>
    <div id="popup-content"></div>
  </div>

  <script>
    // ===== 기본 지도 =====
    const vworldLayer = new ol.layer.Tile({
      source: new ol.source.XYZ({
        url: "http://api.vworld.kr/req/wmts/1.0.0/60DA3367-BC75-32D9-B593-D0386112A70C/Base/{z}/{y}/{x}.png"
      })
    });

    const map = new ol.Map({
      target: "map",
      layers: [vworldLayer],
      view: new ol.View({
        center: ol.proj.fromLonLat([127.024612, 37.5326]), // 서울 중심
        zoom: 11.2, minZoom: 6, maxZoom: 19
      })
    });

    // ===== PM10 색상 =====
    function getPmColor(pm10) {
      if (pm10 == null || pm10 === '') return "gray";
      pm10 = Number(pm10);
      if (pm10 <= 30) return "#00B050";
      if (pm10 <= 80) return "#FFFF00";
      if (pm10 <= 150) return "#FF9900";
      return "#FF0000";
    }

    // ===== JSTL 데이터 주입 =====
    const stationAddrMap = {
      <c:forEach var="s" items="${getDustStation}" varStatus="loop">
        "${s.stationName}": "${s.stationAddr}"<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
    };

    const stations = [
      <c:forEach var="s" items="${getLatestDustData}" varStatus="loop">
        {
          name: "${s.stationName}",
          addr: stationAddrMap["${s.stationName}"] || "",
          lon: ${s.lon},
          lat: ${s.lat},
          pm10: "${s.pm10}",
          pm25: "${s.pm2_5}",
          time: "${s.measureTime}"
        }<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
    ];

    const features = stations.map(s => {
      if (!s.lon || !s.lat) return null;
      return new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.fromLonLat([Number(s.lon), Number(s.lat)])),
        name: s.name, addr: s.addr, pm10: s.pm10, pm25: s.pm25, time: s.time
      });
    }).filter(f => f);

    const stationLayer = new ol.layer.Vector({
      source: new ol.source.Vector({ features }),
      style: function(feature) {
        const pm10 = feature.get("pm10");
        return new ol.style.Style({
          image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({ color: getPmColor(pm10) }),
            stroke: new ol.style.Stroke({ color:"#fff", width:2 })
          }),
          text: new ol.style.Text({
            text: pm10 ? String(pm10) : "-",
            offsetY: -15, font: "bold 11px Noto Sans KR",
            fill: new ol.style.Fill({ color:"#111" }),
            stroke: new ol.style.Stroke({ color:"#fff", width:3 })
          })
        });
      }
    });
    map.addLayer(stationLayer);

    // ===== 팝업 =====
    const container = document.getElementById("popup");
    const content = document.getElementById("popup-content");
    const closer = document.getElementById("popup-closer");

    const overlay = new ol.Overlay({
      element: container,
      autoPan: true,
      autoPanAnimation: { duration: 250 }
    });
    map.addOverlay(overlay);

    closer.onclick = function() {
      overlay.setPosition(undefined);
      closer.blur();
      return false;
    };

    map.on("singleclick", evt => {
      const hit = map.getFeaturesAtPixel(evt.pixel);
      if (hit && hit.length) {
        const p = hit[0].getProperties();
        content.innerHTML =
          "<b>측정소명: " + (p.name || '-') + "</b><br/>" +
          "주소: " + (p.addr || '-') + "<br/>" +
          "PM10: " + (p.pm10 || '-') + "<br/>" +
          "PM2.5: " + (p.pm25 || '-') + "<br/>" +
          "시간: " + (p.time || '-');
        overlay.setPosition(evt.coordinate);
      } else {
        overlay.setPosition(undefined);
      }
    });

    // ===== 줌 컨트롤 =====
    document.getElementById("zoomIn").onclick = () => {
      const view = map.getView();
      view.setZoom(view.getZoom() + 1);
    };
    document.getElementById("zoomOut").onclick = () => {
      const view = map.getView();
      view.setZoom(view.getZoom() - 1);
    };

    // ===== 측정소 갱신 버튼 =====
    const refreshBtn = document.getElementById("refreshBtn");
    const lastRefreshKey = "stationLastRefresh";
    refreshBtn.onclick = function() {
      const now = new Date();
      const last = localStorage.getItem(lastRefreshKey);
      if (last) {
        const lastDate = new Date(last);
        const diffDays = Math.floor((now - lastDate) / (1000*60*60*24));
        if (diffDays < 30) {
          alert("이미 갱신되었습니다 (" + lastDate.toLocaleDateString() + ")");
          return;
        }
      }
      alert("측정소 정보를 갱신했습니다.");
      localStorage.setItem(lastRefreshKey, now.toISOString());
    };

    // ===== 황사 메뉴 토글 =====
    (function(){
      var toggle = document.getElementById('dustToggle');
      var sub    = document.getElementById('dustSub');
      if (!toggle || !sub) return;
      function setOpen(open){
        toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        sub.classList.toggle('open', open);
        sub.style.maxHeight = open ? (sub.scrollHeight + 'px') : '0px';
      }
      toggle.addEventListener('click', function(e){
        e.preventDefault();
        setOpen(toggle.getAttribute('aria-expanded') !== 'true');
      });
      if (/(\/dust|\/realDust)(\/)?$/.test(location.pathname)) setOpen(true);
    })();
  </script>

  <!-- ===== Footer ===== -->
  <footer>
    © 사회기반시설 스마트 유지관리 시스템
  </footer>
</body>
</html>
