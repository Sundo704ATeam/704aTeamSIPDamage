<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템 · PM10 실시간 + 1개월 타임라인</title>

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
    :root { --footer-h: 48px; --tool-w: 120px; }
    html, body { margin:0; height:100%; font-family: system-ui, -apple-system, Segoe UI, Roboto, 'Noto Sans KR', sans-serif; }

    #map{
      position: fixed;
      top: var(--header-h, 60px);
      left: calc(var(--rail-w, 60px) + var(--tool-w));
      right: 0;
      bottom: calc(var(--footer-h) + 56px);
      z-index: 1;
      background:#eef2f7;
    }

    #dataRail{
      position: fixed; z-index: 900;
      top: var(--header-h, 60px); left: var(--rail-w, 60px);
      bottom: var(--footer-h, 48px);
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

    .subnav{ display:none; flex-direction:column; gap:8px; margin-top:-2px; }
    .subnav.open{ display:flex; }
    .subnav a{
      padding:8px 10px; font-size:13px; border-radius:10px;
      border:1px dashed #9ca3af; background:#fff; text-align:left;
    }
    .subnav a::before{ content:"•"; margin-right:6px; font-weight:700; }
    .subnav a:hover{ background:#f3f4f6; }

    #legendBar{
      position: fixed; z-index: 950;
      top: calc(var(--header-h, 60px) + 12px);
      right: 12px; width: 48px; height: 220px;
      display: flex; gap: 8px; align-items: stretch;
      pointer-events: none; font-size: 11px; color:#333;
    }
    #legendBar .bar{
      width: 18px; height: 100%; border: 1px solid #bbb; border-radius: 3px;
      background: linear-gradient(
        to top,
        #60a5fa 0%,   #60a5fa 15%,
        #eab308 15%,  #eab308 40%,
        #f97316 40%,  #f97316 75%,
        #ef4444 75%,  #ef4444 100%
      );
    }
    #legendBar .labels{ position: relative; width: 28px; height: 100%; }
    #legendBar .labels span{
      position: absolute; right: 0; transform: translateY(50%);
      background: rgba(255,255,255,0.7); padding: 0 2px; border-radius: 2px;
    }
    #legendBar .labels span::before{
      content: ""; position: absolute; left: -8px; top: 50%;
      width: 6px; height: 1px; background: #666; transform: translateY(-50%);
    }

    #timelineDock{
      position: fixed; z-index: 960;
      left: calc(var(--rail-w, 60px) + var(--tool-w) + 12px);
      right: 12px; bottom: calc(var(--footer-h) + 8px);
      background:#ffffffee; border:1px solid #e5e7eb; border-radius:12px;
      padding:10px 12px; display:flex; align-items:center; gap:12px;
      backdrop-filter: blur(2px);
    }
    #slider{ flex:1; }
    #tslabel{ min-width: 160px; text-align:right; font-size:12px; color:#334155; }

    footer{
      position: fixed; left:0; right:0; bottom:0;
      height: var(--footer-h);
      background: #333; color:#fff;
      display:flex; align-items:center; justify-content:center;
      border-top:1px solid #444; z-index: 1000;
    }

    #loading{
      position:fixed; z-index:970; left:50%;
      top: calc(var(--header-h, 60px) + 56px);
      transform: translateX(-50%);
      background:#ffffffee; border:1px solid #e5e7eb; border-radius:10px;
      padding:8px 12px; font-size:13px; color:#111; backdrop-filter:blur(2px);
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <aside id="dataRail">
    <a href="${pageContext.request.contextPath}/rain">강우량</a>
    <a href="#" id="dustToggle" aria-expanded="false" aria-controls="dustSub">황사</a>
    <div id="dustSub" class="subnav" role="region" aria-label="황사 하위 메뉴">
      <a class="sub-link" href="${pageContext.request.contextPath}/dust">실시간 PM10 측정정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dust24">PM10 예측정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest">측정소 3개월 타임라인</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest2">측정소 1개월 타임라인+실시간</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/realDust">실시간 PM10/PM2.5 측정 정보</a>
    </div>
  </aside>

  <div id="map"></div>

  <div id="timelineDock">
    <strong>1개월</strong>
    <input id="slider" type="range" min="0" max="0" step="1" value="0" />
    <div id="tslabel">오늘 · 실시간</div>
  </div>

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

  <div id="loading" hidden>데이터 수집 중…</div>
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

  <script>
    /* ===== 고정 설정 ===== */
    var SERVICE_KEY = '618d2c5b94a2d50f226246011a65cfbd793aefab6972a7408e4e15236bb33ad6';
    var BASE_AIR    = 'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
    var PATH_REAL   = '/getCtprvnRltmMesureDnsty';
    var PATH_BY_STN = '/getMsrstnAcctoRltmMesureDnsty';
    var BASE_INFO   = 'https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc';
    var PATH_INFO   = '/getMsrstnList';
    var LOCAL_PROXY = '${pageContext.request.contextPath}/proxy.jsp';

    var SIDO_LIST     = ['서울'];     // 실시간 요청 시 대상 시/도
    var TIMELINE_SIDO = '서울';      // 타임라인 대상 시/도
    var DAYS_BACK     = 30;          // 1개월(30일) + 오늘 = 31스텝

    /* ===== 좌측 메뉴 토글 ===== */
    (function(){
      var btn = document.getElementById('dustToggle');
      var sub = document.getElementById('dustSub');
      if (!btn || !sub) return;
      btn.addEventListener('click', function(e){
        e.preventDefault();
        var opened = sub.classList.toggle('open');
        btn.setAttribute('aria-expanded', opened ? 'true' : 'false');
      });
      document.addEventListener('click', function(e){
        if (!sub.classList.contains('open')) return;
        if (!e.target.closest('#dustToggle') && !e.target.closest('#dustSub')){
          sub.classList.remove('open');
          btn.setAttribute('aria-expanded','false');
        }
      });
    })();

    /* ===== bbox(서울) ===== */
    var SEOUL_BBOX = { minLon:126.76, maxLon:127.18, minLat:37.41, maxLat:37.70 };
    function isInSeoulLonLat(lon, lat){
      return lon >= SEOUL_BBOX.minLon && lon <= SEOUL_BBOX.maxLon &&
             lat >= SEOUL_BBOX.minLat && lat <= SEOUL_BBOX.maxLat;
    }

    /* ===== 유틸 ===== */
    function fetchTextViaLocalProxy(url){
      return fetch(LOCAL_PROXY + '?url=' + encodeURIComponent(url))
        .then(function(res){ if(!res.ok) throw new Error('HTTP '+res.status); return res.text(); });
    }
    function tryParseJSON(text){ try { return JSON.parse(text); } catch(e){ return null; } }
    function parseXML(text){ return (new DOMParser()).parseFromString(text, 'text/xml'); }
    function isLngLat(lon, lat){ return isFinite(lon) && isFinite(lat) && lon > 124 && lon < 132 && lat > 33 && lat < 39; }
    function avg(arr){ var s=0,c=0; for (var i=0;i<arr.length;i++){ var v=arr[i]; if (isFinite(v)){ s+=v; c++; } } return c? s/c : NaN; }
    function num(x){ var n = Number(String(x==null?'':x).trim()); return isFinite(n)? n: NaN; }

    // dmX/dmY의 순서가 들쑥날쑥하므로 양쪽 후보 + TM변환까지 다 시도
    function pickLonLat(dmX, dmY, tmX, tmY){
      var cands = [];
      if (isFinite(dmX) && isFinite(dmY)){
        cands.push([dmX, dmY]); // (lon,lat) 가정
        cands.push([dmY, dmX]); // (lat,lon) 가정
      }
      if (isFinite(tmX) && isFinite(tmY) && window.proj4){
        try{
          var w = proj4('EPSG:5179','WGS84',[tmX, tmY]); // [lon,lat]
          cands.push([w[0], w[1]]);
        }catch(e){}
      }
      for (var i=0;i<cands.length;i++){
        var lon=cands[i][0], lat=cands[i][1];
        if (isLngLat(lon,lat)) return [lon,lat];
      }
      return null;
    }
    
    // 숫자 파서 & 표시 포맷
    function parsePM(s){
      if (s == null) return NaN;
      if (typeof s === 'number') return isFinite(s) ? s : NaN;
      s = String(s).trim();
      if (s === '' || s === '-' || s.toUpperCase() === 'NaN') return NaN;
      var n = Number(s);
      return isFinite(n) ? n : NaN;
    }
    function fmtPM10(v){
      if (!isFinite(v)) return '';
      // 정수로 표시(원하면 toFixed(1)로 바꾸세요)
      return String(Math.round(v));
    }

    // 날짜 유틸(로컬 기준 Y-M-D)
    function ymd(d){
      var y=d.getFullYear(), m=('0'+(d.getMonth()+1)).slice(-2), dd=('0'+d.getDate()).slice(-2);
      return y+'-'+m+'-'+dd;
    }
    function buildLastNDaysKeys(n){ // n=30 -> 30일 전 ~ 오늘 (오름차순)
      var out=[], today=new Date(); today.setHours(0,0,0,0);
      for (var i=n; i>=0; i--){
        var dt = new Date(today); dt.setDate(today.getDate() - i);
        out.push(ymd(dt));
      }
      return out;
    }

    // 안전한 hasOwn
    function hasOwn(obj, key){ return Object.prototype.hasOwnProperty.call(obj, key); }

    // 결측 보간(전후값으로 채우기)
    function fillGaps(dayMap, dateKeys){
      var filled = Object.create(null);

      // 1) 복사 + NaN 초기화
      for (var i=0;i<dateKeys.length;i++){
        var d = dateKeys[i];
        var v = hasOwn(dayMap, d) ? parsePM(dayMap[d]) : NaN;
        filled[d] = isFinite(v) ? v : NaN;
      }

      // 2) forward fill
      var last = NaN;
      for (var j=0;j<dateKeys.length;j++){
        var d1=dateKeys[j];
        if (isFinite(filled[d1])) last = filled[d1];
        else if (isFinite(last)) filled[d1] = last;
      }

      // 3) backward fill
      var next = NaN;
      for (var k=dateKeys.length-1;k>=0;k--){
        var d2=dateKeys[k];
        if (isFinite(filled[d2])) next = filled[d2];
        else if (isFinite(next)) filled[d2] = next;
      }

      return filled;
    }
    
    function getText(node, tag){
      var el = node.getElementsByTagName(tag)[0];
      return el ? el.textContent : '';
    }

    /* ===== 파서 ===== */
    function parseStationItemsToMap(rawText){
    var map = Object.create(null);
    var j = tryParseJSON(rawText);

    // JSON 응답
    if (j && j.response && j.response.body && Array.isArray(j.response.body.items)){
      var items = j.response.body.items;
      for (var i=0;i<items.length;i++){
        var it   = items[i];
        var name = (it.stationName || '').trim();
        if (!name) continue;
        var ll = pickLonLat(num(it.dmX), num(it.dmY), num(it.tmX), num(it.tmY));
        if (ll) map[name] = ll;
      }
      return map;
    }

    // XML fallback
    var xml = parseXML(rawText);
    var nodes = xml.getElementsByTagName('item');
    for (var k=0;k<nodes.length;k++){
      var n    = nodes[k];
      var name = (getText(n,'stationName') || '').trim();
      if (!name) continue;
      var dmX = num(getText(n,'dmX'));
      var dmY = num(getText(n,'dmY'));
      var tmX = num(getText(n,'tmX'));
      var tmY = num(getText(n,'tmY'));
      var ll  = pickLonLat(dmX, dmY, tmX, tmY);
      if (ll) map[name] = ll;
    }
    return map;
  }

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

    /* ===== 색상 ===== */
    function colorByPM10(v){
      if (!isFinite(v)) return '#60a5fa';
      if (v >= 151) return '#ef4444';
      if (v >= 81)  return '#f97316';
      if (v >= 31)  return '#eab308';
      return '#60a5fa';
    }

    /* ===== 지도 & 레이어 ===== */
    var olMap = new ol.Map({
      target: 'map',
      layers: [ new ol.layer.Tile({ source: new ol.source.OSM() }) ],
      view: new ol.View({ center: ol.proj.fromLonLat([127.024612, 37.5326]), zoom: 11 })
    });

    // 실시간
    var rtSource = new ol.source.Vector();
    var rtLayer  = new ol.layer.Vector({
      source: rtSource, zIndex: 999,
      style: function(f){
        var v=Number(f.get('value')), fill=colorByPM10(v);
        var r=Math.max(6, Math.min(18, (isFinite(v)? v:0)/10 + 8));
        var zoom = olMap.getView().getZoom ? olMap.getView().getZoom() : 11;
        var label = (zoom >= 10 && isFinite(v)) ? fmtPM10(v) : '';
        return new ol.style.Style({
          image: new ol.style.Circle({
            radius: r,
            fill: new ol.style.Fill({ color: fill }),
            stroke: new ol.style.Stroke({ color:'#111', width:1 })
          }),
          text: new ol.style.Text({
            text: label, offsetY:-16,
            fill: new ol.style.Fill({ color:'#111' }),
            stroke: new ol.style.Stroke({ color:'#fff', width:3 }),
            font: 'bold 12px sans-serif'
          })
        });
      }
    });
    olMap.addLayer(rtLayer);

    // 타임라인(일 단위)
    var tlSource = new ol.source.Vector();
    var tlLayer  = new ol.layer.Vector({
      source: tlSource, zIndex: 1000, visible: false,
      style: function(f){
        var v=Number(f.get('value')), fill=colorByPM10(v);
        var r=Math.max(6, Math.min(18, (isFinite(v)? v:0)/10 + 8));
        var zoom = olMap.getView().getZoom ? olMap.getView().getZoom() : 11;
        var label = (zoom >= 10 && isFinite(v)) ? fmtPM10(v) : '';
        return new ol.style.Style({
          image: new ol.style.Circle({
            radius: r,
            fill: new ol.style.Fill({ color: fill }),
            stroke: new ol.style.Stroke({ color:'#111', width:1 })
          }),
          text: new ol.style.Text({
            text: label, offsetY:-16,
            fill: new ol.style.Fill({ color:'#111' }),
            stroke: new ol.style.Stroke({ color:'#fff', width:3 }),
            font: 'bold 12px sans-serif'
          })
        });
      }
    });
    olMap.addLayer(tlLayer);

    olMap.getView().on('change:resolution', function(){ rtLayer.changed(); tlLayer.changed(); });

    /* ===== 데이터 적재 ===== */

    // (A) 실시간
    function loadRealtimeAll(){
      rtSource.clear();
      var coordMap = Object.create(null);
      var feats = [];

      var infoPromises = SIDO_LIST.map(function(sido){
        var qs = new URLSearchParams({
          serviceKey: SERVICE_KEY, returnType: 'json',
          numOfRows: '1000', pageNo: '1', addr: sido
        }).toString();
        var url = BASE_INFO + PATH_INFO + '?' + qs;
        return fetchTextViaLocalProxy(url).then(function(txt){
          var m = parseStationItemsToMap(txt);
          for (var k in m) coordMap[k] = m[k];
        }).catch(function(e){ console.warn('[좌표] '+sido+' 실패:', e.message||e); });
      });

      var rtList = [];
      var rtPromises = SIDO_LIST.map(function(sido){
        var qs = new URLSearchParams({
          serviceKey: SERVICE_KEY, returnType:'json',
          numOfRows:'200', pageNo:'1', sidoName:sido, ver:'1.3'
        }).toString();
        var url = BASE_AIR + PATH_REAL + '?' + qs;
        return fetchTextViaLocalProxy(url).then(function(txt){
          var arr = parseRealtimeItems(txt);
          if (Array.isArray(arr)) rtList = rtList.concat(arr);
        }).catch(function(e){ console.warn('[실시간] '+sido+' 실패:', e.message||e); });
      });

      return Promise.all(infoPromises.concat(rtPromises)).then(function(){
        for (var i=0;i<rtList.length;i++){
          var it = rtList[i];
          var name = it.stationName;
          if (!name) continue;
          var coord = coordMap[name];
          if (!coord) continue;
          var val  = parsePM(it.pm10Value);
          feats.push(new ol.Feature({
            geometry: new ol.geom.Point(ol.proj.fromLonLat(coord)),
            name: name, value: isFinite(val)? val: NaN
          }));
        }
        if (feats.length) {
          rtSource.addFeatures(feats);
          var seoulFeats = feats.filter(function(f){
            var ll = ol.proj.toLonLat(f.getGeometry().getCoordinates());
            return isInSeoulLonLat(ll[0], ll[1]);
          });
          if (seoulFeats.length){
            var tmp = new ol.source.Vector({ features: seoulFeats });
            olMap.getView().fit(tmp.getExtent(), { padding:[50,50,50,50], maxZoom:12 });
          }
        }
      });
    }

    // (B) 타임라인(1개월)
    var timeline = [];                  // ['YYYY-MM-DD'] (고정: 30일 전 ~ 오늘)
    var tlFeatureByStation = {};        // name -> Feature
    var seriesPerStation = {};          // name -> { 'YYYY-MM-DD': value }

    function loadTimelineOneMonth(){
      timeline = buildLastNDaysKeys(DAYS_BACK); // <= 여기! 1개월 축 고정
      tlSource.clear(); tlFeatureByStation = {}; seriesPerStation = {};

      var qs1 = new URLSearchParams({
        serviceKey:SERVICE_KEY, returnType:'json',
        numOfRows:'1000', pageNo:'1', addr: TIMELINE_SIDO
      }).toString();
      var url1 = BASE_INFO + PATH_INFO + '?' + qs1;

      function loadSeries(stationName){
        var pageNo=1, num=1000, out=[], total=null;
        function one(){
          var qs = new URLSearchParams({
            serviceKey:SERVICE_KEY, returnType:'json',
            numOfRows:String(num), pageNo:String(pageNo),
            stationName: stationName, dataTerm:'MONTH', ver:'1.0'
          }).toString();
          var url = BASE_AIR + PATH_BY_STN + '?' + qs;
          return fetchTextViaLocalProxy(url).then(function(txt){
            var j=tryParseJSON(txt);
            if (j && j.response && j.response.header && j.response.header.resultCode && j.response.header.resultCode!=='00'){
              throw new Error('API 오류: '+j.response.header.resultCode+' / '+(j.response.header.resultMsg||''));
            }
            if (j && j.response && j.response.body){
              var b=j.response.body;
              total = (total==null)? Number(b.totalCount||0) : total;
              out = out.concat(b.items||[]);
            } else {
              var xml=parseXML(txt);
              var err=xml.querySelector('OpenAPI_ServiceResponse');
              if (err){
                var code=(xml.querySelector('returnReasonCode')||{}).textContent||'UNKNOWN';
                var msg =(xml.querySelector('returnAuthMsg')||{}).textContent||(xml.querySelector('returnReasonMsg')||{}).textContent||'API error';
                throw new Error('API 오류: '+code+' / '+msg);
              }
              var list=xml.getElementsByTagName('item');
              for (var i=0;i<list.length;i++){
                var it=list[i];
                function g(t){ var n=it.getElementsByTagName(t)[0]; return n?n.textContent:''; }
                out.push({ dataTime:g('dataTime'), pm10Value:g('pm10Value'), pm10Value24:g('pm10Value24'), pm25Value:g('pm25Value') });
              }
              total = (total==null)? out.length : total;
            }
          });
        }
        return one().then(function iter(){
          if (total!=null && out.length<total){ pageNo++; return one().then(iter); }
          out.sort(function(a,b){ return new Date(a.dataTime)-new Date(b.dataTime); });
          return out;
        });
      }

      function runQueue(arr, limit, worker){
        var i=0, active=0, results=new Array(arr.length);
        return new Promise(function(resolve){
          function next(){
            if (i>=arr.length && active===0) return resolve(results);
            while(active<limit && i<arr.length){
              (function(idx){
                active++;
                Promise.resolve(worker(arr[idx], idx))
                  .then(function(res){ results[idx]=res; })
                  .catch(function(e){ console.warn('시계열 실패:', arr[idx], e.message||e); results[idx]=null; })
                  .finally(function(){ active--; next(); });
              })(i++);
            }
          }
          next();
        });
      }

      return fetchTextViaLocalProxy(url1)
        .then(parseStationItemsToMap)
        .then(function(coordMap){
          var stationNames = Object.keys(coordMap);
          if (!stationNames.length) throw new Error('측정소 좌표 없음('+TIMELINE_SIDO+')');

          // 지도 피처 생성
          stationNames.forEach(function(name){
            var ll = coordMap[name];
            var f = new ol.Feature({ geometry: new ol.geom.Point(ol.proj.fromLonLat(ll)), name:name, value:NaN });
            tlSource.addFeature(f);
            tlFeatureByStation[name] = f;
          });

          // 시계열 수집(동시성 4)
          return runQueue(stationNames, 4, function(stName){
            return loadSeries(stName).then(function(rows){
              var byDate = Object.create(null); // d -> { v24: number|NaN, vals: number[] }
              for (var i=0;i<rows.length;i++){
                var it = rows[i]; var t = it.dataTime||''; var d = t.slice(0,10); if (!d) continue;
                if (!byDate[d]) byDate[d] = { v24:NaN, vals:[] };
                var v24 = parsePM(it.pm10Value24);
                if (isFinite(v24)) byDate[d].v24 = v24;
                var v1 = parsePM(it.pm10Value);
                if (isFinite(v1)) byDate[d].vals.push(v1);
              }
              // 하루 대표값 확정
              var dayMap = Object.create(null);
              timeline.forEach(function(d){
                var o = byDate[d];
                if (o){
                  dayMap[d] = isFinite(o.v24) ? o.v24 : avg(o.vals);
                }
              });
              // 축 기준 결측 보간
              seriesPerStation[stName] = fillGaps(dayMap, timeline);
            });
          }).then(function(){
            // 슬라이더 세팅 (0 ~ timeline.length) : 마지막 = 오늘(실시간)
            var slider = document.getElementById('slider');
            slider.max = Math.max(0, timeline.length); // timeline.length == 마지막 과거 idx+1
            slider.value = slider.max; // 기본: 오늘(실시간)
            updateSliderLabel();
          });
        });
    }

    /* ===== 표시 제어 ===== */
    var sliderEl = document.getElementById('slider');
    var tslabel  = document.getElementById('tslabel');
    var loadingEl= document.getElementById('loading');

    function showLoading(b,msg){ loadingEl.hidden=!b; if(msg) loadingEl.textContent=msg; }

    function updateSliderLabel(){
      var idx = Number(sliderEl.value)||0;
      if (idx === Number(sliderEl.max)) {
        tslabel.textContent = '오늘 · 실시간';
      } else {
        var d = timeline[idx] || '-';
        tslabel.textContent = d + ' · 일(24h) 단위';
      }
    }

    function renderTimelineFrame(idx){
      if (!timeline.length) return;
      var dateKey = timeline[idx];

      Object.keys(tlFeatureByStation).forEach(function(name){
        var f = tlFeatureByStation[name];
        var m = seriesPerStation[name] || {};
        var v = parsePM(m[dateKey]);
        f.set('value', isFinite(v) ? v : NaN);
      });
      tlLayer.changed();
    }
    
    // 슬라이더: 끝(오늘) -> 실시간 / 그 전 -> 타임라인
    sliderEl.addEventListener('input', function(){
      var idx = Number(sliderEl.value)||0;
      var atRealtime = (idx === Number(sliderEl.max));
      if (atRealtime) {
        tlLayer.setVisible(false);
        rtLayer.setVisible(true);
      } else {
        renderTimelineFrame(idx);
        rtLayer.setVisible(false);
        tlLayer.setVisible(true);
      }
      updateSliderLabel();
    });

    /* ===== 초기 구동 ===== */
    (function init(){
      showLoading(true,'실시간 로딩…');
      loadRealtimeAll()
        .then(function(){
          showLoading(true,'1개월 타임라인 로딩…');
          return loadTimelineOneMonth();
        })
        .catch(function(e){
          console.error(e);
          alert('데이터 로드 실패: ' + (e.message||e));
        })
        .finally(function(){ showLoading(false); });
    })();
  </script>
</body>
</html>
