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
    .ol-popup {
      position: absolute; background: white;
      box-shadow: 0 1px 4px rgba(0,0,0,0.2);
      padding: 10px; border-radius: 8px; border: 1px solid #cccccc;
      min-width: 200px; 
    }
  </style>
</head>
<body>
  <!-- 메뉴 -->
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <aside id="dataRail">
    <div style="text-align: center;">
      <label class="form-label text-black">사회기반시설 선택</label>
      <div class="d-grid gap-2">
        <button id="btnBridge" class="btn btn-light btn-sm">교량</button>
        <button id="btnFootbridge" class="btn btn-light btn-sm">육교</button>
        <button id="btnTunnel" class="btn btn-light btn-sm">터널</button>
        <button id="btnStruc" class="btn btn-light btn-sm">건축물</button>
        <button id="btnCheoldo" class="btn btn-light btn-sm">철도</button>
        <button id="btnHachun" class="btn btn-light btn-sm">하천</button>
        <button id="btnAll" class="btn btn-light btn-sm">전체 보기</button>
        <button id="btnAlldown" class="btn btn-light btn-sm">전체 해제</button>
      </div>
    </div>
  </aside>

  <button id="toggleRailBtn" class="rail-toggle" aria-expanded="true" title="데이터레일 접기">◀</button>
  <div id="map"></div>
  <div id="popup" class="ol-popup"></div>
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

<script>
  // === Vworld WMTS 배경지도 ===
  const vworldLayer = new ol.layer.Tile({
    source: new ol.source.XYZ({
      url: "http://api.vworld.kr/req/wmts/1.0.0/"
           + "60DA3367-BC75-32D9-B593-D0386112A70C"
           + "/Base/{z}/{y}/{x}.png"
    })
  });

  const map = new ol.Map({
    target: "map",
    layers: [vworldLayer],
    view: new ol.View({
      center: ol.proj.fromLonLat([127.024612, 37.5326]),
      zoom: 12, projection: "EPSG:3857"
    })
  });

  // === 팝업 ===
  const popupEl = document.getElementById("popup");
  const overlay = new ol.Overlay({
    element: popupEl, autoPan:true, autoPanAnimation:{duration:250}
  });
  map.addOverlay(overlay);

  function showPopup(coord, html) {
    popupEl.innerHTML = html;
    overlay.setPosition(coord);
  }

  // === 통합 클릭 이벤트 ===
  map.on("singleclick", (evt) => {
    overlay.setPosition(undefined);
    popupEl.innerHTML = "";

    const layers = [
      window.gyoryangLayer,
      window.yookgyoLayer,
      window.tunnelLayer,
      window.mapoLayer,
      window.cheoldoLayer,
      window.hachunLayer
    ];

    for (const layer of layers) {
      if (!layer || !layer.getVisible()) continue;

      const url = layer.getSource().getFeatureInfoUrl(
        evt.coordinate,
        map.getView().getResolution(),
        "EPSG:3857",
        { INFO_FORMAT: "application/json" }
      );

      if (url) {
        fetch(url).then(r => r.json()).then(json => {
          if (json.features && json.features.length > 0) {
            const props = json.features[0].properties;
            showPopup(evt.coordinate,
              "<b>이름:</b> " + (props.name || "없음")
            );
          }
        });
        break; // ★ 첫 번째로 걸린 레이어만 처리
      }
    }
  });

  // === 토글 유틸 ===
  function bindToggle(btnId, layer) {
    const btn = document.getElementById(btnId);
    if (!btn) return;
    btn.addEventListener("click", () => {
      const next = !layer.getVisible();
      layer.setVisible(next);
      btn.classList.toggle("active", next);

      if (!next) {
        overlay.setPosition(undefined); // 레이어 꺼지면 팝업 닫기
      }
    });
  }

  // === 전체 보기/해제 ===
  const allBtns = [
    ["btnBridge", "gyoryangLayer"],
    ["btnFootbridge", "yookgyoLayer"],
    ["btnTunnel", "tunnelLayer"],
    ["btnStruc", "mapoLayer"],
    ["btnCheoldo", "cheoldoLayer"],
    ["btnHachun", "hachunLayer"]
  ];

  document.getElementById("btnAll").addEventListener("click", () => {
    allBtns.forEach(([id, varName]) => {
      window[varName].setVisible(true);
      document.getElementById(id)?.classList.add("active");
    });
  });

  document.getElementById("btnAlldown").addEventListener("click", () => {
    allBtns.forEach(([id, varName]) => {
      window[varName].setVisible(false);
      document.getElementById(id)?.classList.remove("active");
    });
    overlay.setPosition(undefined);
  });

  // === 사이드바 접기 ===
  const toggleBtn = document.getElementById("toggleRailBtn");
  toggleBtn?.addEventListener("click", () => {
    document.body.classList.toggle("rail-collapsed");
    const collapsed = document.body.classList.contains("rail-collapsed");
    toggleBtn.setAttribute("aria-expanded", String(!collapsed));
    toggleBtn.title = collapsed ? "데이터레일 펼치기" : "데이터레일 접기";
    toggleBtn.textContent = collapsed ? "▶" : "◀";
    setTimeout(() => map.updateSize(), 260);
  });
</script>

  <!-- 레이어 분리 include -->
  <jsp:include page="/WEB-INF/views/sj/layers/hachun.jsp"/>
  <jsp:include page="/WEB-INF/views/sj/layers/footbridge.jsp"/> 
  <jsp:include page="/WEB-INF/views/sj/layers/bridge.jsp"/>
  <jsp:include page="/WEB-INF/views/sj/layers/tunnel.jsp"/>
  <jsp:include page="/WEB-INF/views/sj/layers/building.jsp"/>
  <jsp:include page="/WEB-INF/views/sj/layers/railway.jsp"/>
</body>
</html>
