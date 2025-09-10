<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>

  <!-- OpenLayers & Proj4 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css">
  <script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/proj4@2.9.0/dist/proj4.js"></script>
  <script>
    if (window.proj4 && window.ol && ol.proj && ol.proj.proj4) {
      ol.proj.proj4.register(proj4);
      proj4.defs('EPSG:5179',
        '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 ' +
        '+x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs +type=crs'
      );
    }
  </script>

  <style>
    :root { --footer-h: 40px; --tool-w: 120px; }
    html, body { margin:0; height:100%; }
    #map{
      position: fixed;
      top: var(--header-h, 60px);
      left: calc(var(--rail-w, 60px) + var(--tool-w));
      right: 0;
      bottom: var(--footer-h, 40px);
      z-index: 1;
    }
    footer{
      position: fixed; left:0; right:0; bottom:0;
      height: var(--footer-h, 40px);
      background: #333; color:#fff;
      display:flex; align-items:center; justify-content:center;
      border-top:1px solid #444; z-index: 1000;
    }
    #dataRail{
      position: fixed; z-index: 900;
      top: var(--header-h, 60px); left: var(--rail-w, 60px);
      bottom: var(--footer-h, 40px);
      width: var(--tool-w); background: #f3f3f3;
      border-right:1px solid #ddd;
      padding: 12px 10px; display:flex; flex-direction:column; gap:10px;
    }
    #dataRail a{
      display:block; width:100%; padding:10px 12px;
      text-align:center; border-radius:10px;
      text-decoration:none; border:1px solid #6b7280;
      background:#fff; color:#111;
    }
    #dataRail a:hover{ background:#e5e7eb; }

    /* ── 하위 메뉴(황사 하단) ───────────────────────── */
    .subnav{
      display:none; flex-direction:column; gap:8px; margin-top:-2px;
    }
    .subnav.open{ display:flex; }
    .subnav a{
      padding:8px 10px;
      font-size:13px;
      border-radius:10px;
      border:1px dashed #9ca3af;
      background:#fff;
      text-align:left;
    }
    .subnav a::before{
      content:"•";
      margin-right:6px;
      font-weight:700;
    }
    .subnav a:hover{ background:#f3f4f6; }

    /* ── 우측 색상 바 (PM10 생활지수 기준) ───────────── */
    #legendBar{
      position: fixed; z-index: 950;
      top: calc(var(--header-h, 60px) + 12px);
      right: 12px;
      width: 48px; height: 220px;
      display: flex; gap: 8px; align-items: stretch;
      pointer-events: none;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, 'Noto Sans KR', sans-serif;
    }
    #legendBar .bar{
      width: 18px; height: 100%;
      border: 1px solid #bbb; border-radius: 3px;
      /* 구간별 단색(계단형) */
      background: linear-gradient(
        to top,
        #60a5fa 0%,   #60a5fa 15%,   /* 0–30 (파랑)  */
        #eab308 15%,  #eab308 40%,   /* 31–80 (노랑) */
        #f97316 40%,  #f97316 75%,   /* 81–150(주황) */
        #ef4444 75%,  #ef4444 100%   /* 151+ (빨강) */
      );
    }
    #legendBar .labels{ position: relative; width: 28px; height: 100%; font-size: 11px; color:#333; }
    #legendBar .labels span{
      position: absolute; right: 0; transform: translateY(50%);
      background: rgba(255,255,255,0.7); padding: 0 2px; border-radius: 2px;
    }
    #legendBar .labels span::before{
      content: ""; position: absolute; left: -8px; top: 50%;
      width: 6px; height: 1px; background: #666; transform: translateY(-50%);
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <aside id="dataRail">
    <a href="${pageContext.request.contextPath}/rain">강우량</a>

    <!-- 황사 토글 버튼 -->
    <a href="#" id="dustToggle" aria-expanded="false" aria-controls="dustSub">황사</a>
    <!-- 황사 하위 링크 (기본 숨김) -->
    <div id="dustSub" class="subnav" role="region" aria-label="황사 하위 메뉴">
      <a class="sub-link" href="${pageContext.request.contextPath}/dust">실시간 PM10 측정정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dust24">PM10 예측정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest">측정소 3개월 타임라인</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest2">측정소 1개월 타임라인+실시간</a>
    </div>
  </aside>

  <div id="map"></div>

  <!-- PM10 생활지수 색상바 -->
  <aside id="legendBar" aria-label="PM10 생활지수 색상 범례">
    <div class="bar"></div>
    <div class="labels">
      <span style="bottom:100%;">200</span>
      <span style="bottom:75%;">150</span>
      <span style="bottom:40%;">80</span>
      <span style="bottom:15%;">30</span>
      <span style="bottom:0%;">0</span>
    </div>
  </aside>

  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

  <script>
    // ===== 설정 =====
    var SERVICE_KEY = '618d2c5b94a2d50f226246011a65cfbd793aefab6972a7408e4e15236bb33ad6';
    var BASE_AIR    = 'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
    var PATH_REAL   = '/getCtprvnRltmMesureDnsty';
    var BASE_INFO   = 'https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc';
    var PATH_INFO   = '/getMsrstnList';
    var SIDO_LIST   = ['서울'];

    var LOCAL_PROXY = '${pageContext.request.contextPath}/proxy.jsp';

    // ── 황사 하위 메뉴 토글
    (function(){
      var btn = document.getElementById('dustToggle');
      var sub = document.getElementById('dustSub');
      if (!btn || !sub) return;

      btn.addEventListener('click', function(e){
        e.preventDefault();
        var opened = sub.classList.toggle('open');
        btn.setAttribute('aria-expanded', opened ? 'true' : 'false');
      });

      // 바깥을 클릭하면 접기 (선택사항)
      document.addEventListener('click', function(e){
        if (!sub.classList.contains('open')) return;
        if (!e.target.closest('#dustToggle') && !e.target.closest('#dustSub')){
          sub.classList.remove('open');
          btn.setAttribute('aria-expanded', 'false');
        }
      });
    })();

    // 서울 bbox (초기 화면/fit 유지용)
    var SEOUL_BBOX = { minLon:126.76, maxLon:127.18, minLat:37.41, maxLat:37.70 };
    function isInSeoulLonLat(lon, lat){
      return lon >= SEOUL_BBOX.minLon && lon <= SEOUL_BBOX.maxLon &&
             lat >= SEOUL_BBOX.minLat && lat <= SEOUL_BBOX.maxLat;
    }

    function fetchTextViaLocalProxy(url){
      var proxied = LOCAL_PROXY + '?url=' + encodeURIComponent(url);
      return fetch(proxied).then(function(res){
        if (!res.ok) throw new Error('HTTP ' + res.status);
        return res.text();
      });
    }
    function tryParseJSON(text){ try { return JSON.parse(text); } catch(e){ return null; } }
    function parseXML(text){ return (new DOMParser()).parseFromString(text, 'text/xml'); }

    function isLngLat(lon, lat){
      return isFinite(lon) && isFinite(lat) && lon > 124 && lon < 132 && lat > 33 && lat < 39;
    }

    // 측정소 좌표 파서
    function parseStationItemsToMap(rawText){
      var map = Object.create(null);
      var j = tryParseJSON(rawText);
      if (j && j.response && j.response.body){
        var items = j.response.body.items || [];
        for (var i=0;i<items.length;i++){
          var it   = items[i];
          var name = it.stationName;
          var lat = parseFloat(it.dmX);
          var lon = parseFloat(it.dmY);
          if (!isLngLat(lon, lat)) {
            var tmX = parseFloat(it.tmX), tmY = parseFloat(it.tmY);
            if (isFinite(tmX) && isFinite(tmY) && window.proj4) {
              try { var w = proj4('EPSG:5179', 'WGS84', [tmX, tmY]); lon = w[0]; lat = w[1]; } catch(e){}
            }
          }
          if (name && isLngLat(lon,lat)) map[name] = [lon, lat];
        }
        return map;
      }
      var xml = parseXML(rawText);
      var nodes = xml.getElementsByTagName('item');
      for (var k=0;k<nodes.length;k++){
        var n    = nodes[k];
        var name = (n.getElementsByTagName('stationName')[0]||{}).textContent;
        var lat  = parseFloat((n.getElementsByTagName('dmX')[0]||{}).textContent);
        var lon  = parseFloat((n.getElementsByTagName('dmY')[0]||{}).textContent);
        if (!isLngLat(lon, lat)) {
          var tmX = parseFloat((n.getElementsByTagName('tmX')[0]||{}).textContent);
          var tmY = parseFloat((n.getElementsByTagName('tmY')[0]||{}).textContent);
          if (isFinite(tmX) && isFinite(tmY) && window.proj4) {
            try { var w2 = proj4('EPSG:5179', 'WGS84', [tmX, tmY]); lon = w2[0]; lat = w2[1]; } catch(e){}
          }
        }
        if (name && isLngLat(lon,lat)) map[name] = [lon, lat];
      }
      return map;
    }

    // 실시간 PM10 파서
    function parseRealtimeItems(rawText){
      var j = tryParseJSON(rawText);
      if (j && j.response && j.response.body) return j.response.body.items || [];
      var xml = parseXML(rawText);
      var list = [], items = xml.getElementsByTagName('item');
      for (var i=0;i<items.length;i++){
        var it = items[i];
        list.push({
          stationName: (it.getElementsByTagName('stationName')[0]||{}).textContent,
          pm10Value  : (it.getElementsByTagName('pm10Value')[0]||{}).textContent
        });
      }
      return list;
    }

    // 지도 생성
    (function createMap(){
      window.olMap = new ol.Map({
        target: document.getElementById('map'),
        layers: [ new ol.layer.Tile({ source: new ol.source.OSM() }) ],
        view: new ol.View({
          center: ol.proj.fromLonLat([127.024612, 37.5326]),
          zoom: 11
        })
      });
    })();

    // PM10 색상 규칙
    function colorByPM10(v){
      if (!isFinite(v)) return '#60a5fa';
      if (v >= 151) return '#ef4444';
      if (v >= 81)  return '#f97316';
      if (v >= 31)  return '#eab308';
      return '#60a5fa';
    }

    function dustStyle(feature){
      var v = Number(feature.get('value'));
      var fill = colorByPM10(v);
      var r = Math.max(6, Math.min(18, (isFinite(v)? v:0)/10 + 8));
      var zoom = window.olMap && window.olMap.getView().getZoom ? window.olMap.getView().getZoom() : 11;
      var label = (zoom >= 10 && isFinite(v)) ? String(v) : '';
      return new ol.style.Style({
        image: new ol.style.Circle({
          radius: r,
          fill: new ol.style.Fill({ color: fill }),
          stroke: new ol.style.Stroke({ color: '#111', width: 1 })
        }),
        text: new ol.style.Text({
          text: label,
          offsetY: -16,
          fill: new ol.style.Fill({ color: '#111' }),
          stroke: new ol.style.Stroke({ color: '#fff', width: 3 }),
          font: 'bold 12px sans-serif'
        })
      });
    }

    // 데이터 렌더링
    (function renderBySido(){
      var map = window.olMap;
      var src  = new ol.source.Vector();
      var layer = new ol.layer.Vector({ source: src, zIndex: 999, style: dustStyle });
      map.addLayer(layer);
      map.getView().on('change:resolution', function(){ layer.changed(); });

      var coordMap = Object.create(null);
      var infoPromises = SIDO_LIST.map(function(sido){
        var qs = new URLSearchParams({
          serviceKey: SERVICE_KEY, returnType: 'json',
          numOfRows: '1000', pageNo: '1',
          addr: sido
        }).toString();
        var url = BASE_INFO + PATH_INFO + '?' + qs;
        return fetchTextViaLocalProxy(url)
          .then(function(txt){
            var m = parseStationItemsToMap(txt);
            for (var k in m) { coordMap[k] = m[k]; }
          })
          .catch(function(e){ console.warn('[좌표] ' + sido + ' 실패:', e.message || e); });
      });

      var realtimeList = [];
      var realtimePromises = SIDO_LIST.map(function(sido){
        var qs = new URLSearchParams({
          serviceKey: SERVICE_KEY, returnType: 'json',
          numOfRows: '200', pageNo: '1',
          sidoName: sido, ver: '1.3'
        }).toString();
        var url = BASE_AIR + PATH_REAL + '?' + qs;
        return fetchTextViaLocalProxy(url)
          .then(function(txt){
            var arr = parseRealtimeItems(txt);
            if (Array.isArray(arr)) realtimeList = realtimeList.concat(arr);
          })
          .catch(function(e){ console.warn('[실시간] ' + sido + ' 실패:', e.message || e); });
      });

      Promise.all(infoPromises.concat(realtimePromises))
        .then(function(){
          var feats = [];
          for (var i=0;i<realtimeList.length;i++){
            var it = realtimeList[i];
            var name = it.stationName;
            if (!name) continue;
            var coord = coordMap[name];
            if (!coord) continue;
            var pm10 = it.pm10Value;
            var val  = (pm10 && pm10 !== '-') ? Number(pm10) : NaN;

            feats.push(new ol.Feature({
              geometry: new ol.geom.Point(ol.proj.fromLonLat(coord)),
              name: name,
              value: val
            }));
          }

          if (feats.length){
            src.clear(); src.addFeatures(feats);
            // 서울 영역만 fit
            var seoulFeats = feats.filter(function(f){
              var lonlat = ol.proj.toLonLat(f.getGeometry().getCoordinates());
              return isInSeoulLonLat(lonlat[0], lonlat[1]);
            });
            if (seoulFeats.length){
              var seoulSrc = new ol.source.Vector({ features: seoulFeats });
              map.getView().fit(seoulSrc.getExtent(), { padding:[50,50,50,50], maxZoom: 12 });
            }
          } else {
            alert('측정소 데이터가 없습니다. (API 권한/응답 확인)');
          }
        })
        .catch(function(e){
          console.error('데이터 수집 실패:', e);
          alert('데이터 요청/파싱 실패: ' + (e.message || e));
        });
    })();
  </script>
</body>
</html>
