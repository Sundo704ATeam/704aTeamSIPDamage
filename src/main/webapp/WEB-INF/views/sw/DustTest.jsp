<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>사회기반시설 스마트 유지관리 시스템 - 측정소 3개월 지도 애니메이션(일 간격)</title>

  <!-- OpenLayers & Proj4 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css">
  <script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/proj4@2.9.0/dist/proj4.js"></script>
  <script>
    if (window.proj4 && window.ol && ol.proj && ol.proj.proj4) {
      ol.proj.proj4.register(proj4);
      proj4.defs('EPSG:5179',
        '+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m +no_defs +type=crs'
      );
    }
  </script>

  <style>
    :root{ --footer-h:40px; --tool-w:120px; }
    html,body{ margin:0; height:100%; background:#f7f7f7; font-family:system-ui,-apple-system,Segoe UI,Roboto,'Noto Sans KR',sans-serif; }

    /* 좌측 레일 */
    #dataRail{ position:fixed; z-index:900; top:var(--header-h,60px); left:var(--rail-w,60px); bottom:var(--footer-h,40px);
      width:var(--tool-w); background:#f3f3f3; border-right:1px solid #ddd; padding:12px 10px; display:flex; flex-direction:column; gap:8px; }
    #dataRail a{ display:block; width:100%; padding:10px 12px; text-align:center; border-radius:10px; text-decoration:none; border:1px solid #6b7280; background:#fff; color:#111; }
    #dataRail a:hover{ background:#e5e7eb; }
    #dataRail .rail-link{ display:flex; align-items:center; justify-content:space-between; width:100%; padding:10px 12px; text-align:left; border-radius:10px; border:1px solid #6b7280; background:#fff; color:#111; cursor:pointer; }
    #dataRail .rail-link:hover{ background:#e5e7eb; }
    #dataRail .caret{ width:0; height:0; margin-left:8px; border-left:5px solid transparent; border-right:5px solid transparent; border-top:6px solid #4b5563; transition:transform .2s ease; }
    #dataRail .rail-link[aria-expanded="true"] .caret{ transform:rotate(180deg); }
    #dataRail .submenu{ overflow:hidden; max-height:0; transition:max-height .2s ease; }
    #dataRail .submenu.open{ margin-top:4px; }
    #dataRail .sub-link{ display:block; padding:8px 10px; margin:4px 0 0 6px; font-size:13px; border-radius:8px; border:1px dashed #cbd5e1; background:#fff; color:#111; text-decoration:none; }
    #dataRail .sub-link:hover{ background:#f3f4f6; }

    /* 지도 */
    #map{ position:fixed; z-index:1; top:var(--header-h,60px); left:calc(var(--rail-w,60px) + var(--tool-w)); right:0; bottom:var(--footer-h,40px); background:#eef2f7; }

    /* 컨트롤 (맵 오버레이) */
    #control{ position:fixed; z-index:950; top:calc(var(--header-h,60px) + 12px); left:calc(var(--rail-w,60px) + var(--tool-w) + 12px); right:12px;
      display:grid; grid-template-columns:1fr auto; gap:8px; align-items:center; }
    #toolbar,#player{ background:#ffffffee; border:1px solid #e5e7eb; border-radius:12px; padding:8px 10px; display:flex; align-items:center; gap:8px; backdrop-filter:blur(2px); }
    #toolbar select,#toolbar button{ padding:8px 10px; border-radius:10px; border:1px solid #cbd5e1; background:#fff; color:#111; }
    #toolbar .btn{ background:#4b5563; color:#fff; border-color:#4b5563; }
    #toolbar .btn:hover{ filter:brightness(0.95); }
    #player{ gap:10px; }
    #player button{ padding:8px 10px; border-radius:10px; border:1px solid #cbd5e1; background:#4b5563; color:#fff; }
    #player button:hover{ filter:brightness(0.95); }
    #slider{ width:320px; }
    #tslabel{ font-size:12px; color:#334155; min-width:160px; text-align:right; }

    /* 우측 범례 */
    #legendBar{ position:fixed; z-index:940; top:calc(var(--header-h,60px) + 12px); right:12px; width:48px; height:220px; display:flex; gap:8px; align-items:stretch; pointer-events:none; font-size:11px; color:#333; }
    #legendBar .bar{ width:18px; height:100%; border:1px solid #bbb; border-radius:3px; background:linear-gradient(to top,#60a5fa 0%,#60a5fa 15%,#eab308 15%,#eab308 40%,#f97316 40%,#f97316 75%,#ef4444 75%,#ef4444 100%); }
    #legendBar .labels{ position:relative; width:28px; height:100%; }
    #legendBar .labels span{ position:absolute; right:0; transform:translateY(50%); background:#ffffffcc; padding:0 2px; border-radius:2px; }
    #legendBar .labels span::before{ content:""; position:absolute; left:-8px; top:50%; width:6px; height:1px; background:#666; transform:translateY(-50%); }

    /* 로딩 */
    #loading{ position:fixed; z-index:960; left:50%; top:calc(var(--header-h,60px) + 60px); transform:translateX(-50%); background:#ffffffee; border:1px solid #e5e7eb; border-radius:10px; padding:8px 12px; font-size:13px; color:#111; backdrop-filter:blur(2px); }

    footer{ position:fixed; left:0; right:0; bottom:0; height:var(--footer-h); background:#333; color:#fff; display:flex; align-items:center; justify-content:center; border-top:1px solid #444; z-index:1000; }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <!-- 좌측 레일 -->
  <aside id="dataRail" role="navigation" aria-label="기능 메뉴">
    <a class="rail-link" href="${pageContext.request.contextPath}/rain">강우량</a>
    <button type="button" class="rail-link" id="dustToggle" aria-expanded="false" aria-controls="dustSub">
      황사 <span class="caret" aria-hidden="true"></span>
    </button>
    <div id="dustSub" class="submenu" role="region" aria-label="황사 하위 메뉴">
      <a class="sub-link" href="${pageContext.request.contextPath}/dust">실시간 PM10 측정정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dust24">PM10 예측정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest">측정소 3개월 타임라인</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest2">측정소 1개월 타임라인+실시간</a>
    </div>
  </aside>

  <div id="map"></div>

  <div id="control">
    <div id="toolbar">
      <select id="sido">
        <option>서울</option><option>부산</option><option>대구</option><option>인천</option>
        <option>광주</option><option>대전</option><option>울산</option><option>세종</option>
        <option>경기</option><option>강원</option><option>충북</option><option>충남</option>
        <option>전북</option><option>전남</option><option>경북</option><option>경남</option>
        <option>제주</option>
      </select>
      <select id="field">
        <option value="pm10Value24" selected>PM10 (24시간 이동)</option>
        <option value="pm10Value">PM10 (1시간)</option>
        <option value="pm25Value">PM2.5(1시간)</option>
      </select>
      <button id="btnLoad" class="btn">불러오기</button>
    </div>
    <div id="player">
      <button id="btnPlay">재생</button>
      <button id="btnPause">멈춤</button>
      <input id="slider" type="range" min="0" max="0" step="1" value="0"/>
      <div id="tslabel">-</div>
    </div>
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
    /* 좌측 드롭다운 */
    (function(){
      var toggle = document.getElementById('dustToggle');
      var sub = document.getElementById('dustSub');
      if (!toggle || !sub) return;
      function setOpen(o){ toggle.setAttribute('aria-expanded', o?'true':'false'); sub.classList.toggle('open',o); sub.style.maxHeight = o? (sub.scrollHeight+'px'): '0px'; }
      toggle.addEventListener('click', function(e){ e.preventDefault(); setOpen(toggle.getAttribute('aria-expanded')!=='true'); });
      if (/(\/dust|\/dust24|\/dustStation3mMap)(\/)?$/.test(location.pathname)) setOpen(true);
      window.addEventListener('resize', function(){ if (sub.classList.contains('open')) sub.style.maxHeight = sub.scrollHeight + 'px'; });
    })();

    /* 설정 */
    var SERVICE_KEY='618d2c5b94a2d50f226246011a65cfbd793aefab6972a7408e4e15236bb33ad6';
    var BASE_INFO='https://apis.data.go.kr/B552584/MsrstnInfoInqireSvc';
    var PATH_INFO='/getMsrstnList';
    var BASE_AIR='https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
    var PATH_BY_STN='/getMsrstnAcctoRltmMesureDnsty';
    var LOCAL_PROXY='${pageContext.request.contextPath}/proxy.jsp';
    var MAX_STATIONS=120, CONCURRENCY=4;

    /* 유틸 */
    function fetchTextViaLocalProxy(url){ return fetch(LOCAL_PROXY+'?url='+encodeURIComponent(url)).then(function(r){ if(!r.ok) throw new Error('HTTP '+r.status); return r.text(); }); }
    function tryParseJSON(t){ try{ return JSON.parse(t); }catch(e){ return null; } }
    function parseXML(t){ return (new DOMParser()).parseFromString(t,'text/xml'); }
    function isLngLat(lon,lat){ return isFinite(lon)&&isFinite(lat)&&lon>124&&lon<132&&lat>33&&lat<39; }
    function avg(arr){ var s=0,c=0; for (var i=0;i<arr.length;i++){ var v=arr[i]; if (isFinite(v)){ s+=v; c++; } } return c? s/c : NaN; }

    /* 좌표 파서 */
    function parseStationItemsToMap(rawText){
      var map=Object.create(null);
      var j=tryParseJSON(rawText);
      if (j && j.response && j.response.body){
        var items=j.response.body.items||[];
        for (var i=0;i<items.length;i++){
          var it=items[i], name=it.stationName;
          var lat=parseFloat(it.dmX), lon=parseFloat(it.dmY);
          if (!isLngLat(lon,lat)){
            var tmX=parseFloat(it.tmX), tmY=parseFloat(it.tmY);
            if (isFinite(tmX)&&isFinite(tmY)&&window.proj4){ try{ var w=proj4('EPSG:5179','WGS84',[tmX,tmY]); lon=w[0]; lat=w[1]; }catch(e){} }
          }
          if (name && isLngLat(lon,lat)) map[name]=[lon,lat];
        }
        return map;
      }
      var xml=parseXML(rawText), list=xml.getElementsByTagName('item');
      for (var k=0;k<list.length;k++){
        var n=list[k];
        var name=(n.getElementsByTagName('stationName')[0]||{}).textContent;
        var lat=parseFloat((n.getElementsByTagName('dmX')[0]||{}).textContent);
        var lon=parseFloat((n.getElementsByTagName('dmY')[0]||{}).textContent); /* ← 오타 수정 */
        if (!isLngLat(lon,lat)){
          var tmX=parseFloat((n.getElementsByTagName('tmX')[0]||{}).textContent);
          var tmY=parseFloat((n.getElementsByTagName('tmY')[0]||{}).textContent);
          if (isFinite(tmX)&&isFinite(tmY)&&window.proj4){ try{ var w2=proj4('EPSG:5179','WGS84',[tmX,tmY]); lon=w2[0]; lat=w2[1]; }catch(e){} }
        }
        if (name && isLngLat(lon,lat)) map[name]=[lon,lat];
      }
      return map;
    }

    /* 3개월 시계열(측정소) */
    function loadSeries3Month(stationName){
      var pageNo=1, num=1000, out=[], total=null;
      function one(){
        var qs=new URLSearchParams({
          serviceKey:SERVICE_KEY, returnType:'json',
          numOfRows:String(num), pageNo:String(pageNo),
          stationName:stationName, dataTerm:'3MONTH', ver:'1.0' /* ← 엔드포인트 규격 */
        }).toString();
        var url=BASE_AIR+PATH_BY_STN+'?'+qs;
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
              var it=list[i]; function g(t){ var n=it.getElementsByTagName(t)[0]; return n?n.textContent:''; }
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

    /* 동시성 큐 */
    function runQueue(arr, limit, worker){
      var i=0, active=0, results=new Array(arr.length);
      return new Promise(function(resolve){
        function next(){
          if (i>=arr.length && active===0) return resolve(results);
          while(active<limit && i<arr.length){
            (function(idx){
              active++;
              Promise.resolve(worker(arr[idx], idx)).then(function(res){ results[idx]=res; })
              .catch(function(e){ console.warn('시계열 실패:', arr[idx], e.message||e); results[idx]=null; })
              .finally(function(){ active--; next(); });
            })(i++);
          }
        }
        next();
      });
    }

    /* 색상(원래 규칙) */
    function colorByPM10(v){
      if (!isFinite(v)) return '#60a5fa'; /* 결측도 파랑 */
      if (v>=151) return '#ef4444';
      if (v>=81)  return '#f97316';
      if (v>=31)  return '#eab308';
      return '#60a5fa';
    }

    /* 지도 */
    var olMap=new ol.Map({ target:'map', layers:[ new ol.layer.Tile({ source:new ol.source.OSM() }) ], view:new ol.View({ center:ol.proj.fromLonLat([127.8,36.3]), zoom:7 }) });
    var vectorSrc=new ol.source.Vector();
    var vectorLyr=new ol.layer.Vector({
      source:vectorSrc, zIndex:999,
      style:function(f){
        var v=Number(f.get('value')), fill=colorByPM10(v);
        var r=Math.max(5, Math.min(16, (isFinite(v)? v:0)/10 + 7));
        var zoom=olMap.getView().getZoom ? olMap.getView().getZoom() : 7;
        var label=(zoom>=10 && isFinite(v))? String(v):'';
        return new ol.style.Style({
          image:new ol.style.Circle({ radius:r, fill:new ol.style.Fill({ color:fill }), stroke:new ol.style.Stroke({ color:'#111', width:1 }) }),
          text:new ol.style.Text({ text:label, offsetY:-16, fill:new ol.style.Fill({ color:'#111' }), stroke:new ol.style.Stroke({ color:'#fff', width:3 }), font:'bold 12px sans-serif' })
        });
      }
    });
    olMap.addLayer(vectorLyr);
    olMap.getView().on('change:resolution', function(){ vectorLyr.changed(); });

    /* 상태 */
    var timeline=[];                 // ['YYYY-MM-DD']
    var features=[];                 // 측정소 피처
    var seriesPerStation={};         // { stationName: { 'YYYY-MM-DD': value } }
    var currentIdx=0, timer=null, FPS=3;

    // DOM
    var sidoSel=document.getElementById('sido');
    var fieldSel=document.getElementById('field');
    var btnLoad=document.getElementById('btnLoad');
    var btnPlay=document.getElementById('btnPlay');
    var btnPause=document.getElementById('btnPause');
    var slider=document.getElementById('slider');
    var tslabel=document.getElementById('tslabel');
    var loadingEl=document.getElementById('loading');
    function showLoading(b,msg){ loadingEl.hidden=!b; if(msg) loadingEl.textContent=msg; }

    /* 시/도 좌표 */
    function loadStationCoords(sido){
      var qs=new URLSearchParams({ serviceKey:SERVICE_KEY, returnType:'json', numOfRows:'1000', pageNo:'1', addr:sido }).toString();
      var url=BASE_INFO+PATH_INFO+'?'+qs;
      return fetchTextViaLocalProxy(url).then(parseStationItemsToMap);
    }

    /* 일 단위 타임라인 & 값 구성
       - 우선: 해당 날짜의 'pm10Value24' (있으면)
       - 없으면: 그 날짜에 관측된 'pm10Value'들의 평균값 사용 */
    function buildDailyTimelineAndSeries(stationNames, fieldKey){
      if (stationNames.length>MAX_STATIONS) stationNames = stationNames.slice(0, MAX_STATIONS);
      seriesPerStation={}; timeline=[];

      return runQueue(stationNames, CONCURRENCY, function(name){
        return loadSeries3Month(name).then(function(list){
          var byDate = Object.create(null); // d -> { v24: number|NaN, vals: number[] }
          for (var i=0;i<list.length;i++){
            var it=list[i]; var t=it.dataTime||''; var d=t.slice(0,10); if (!d) continue;
            if (!byDate[d]) byDate[d]={ v24:NaN, vals:[] };

            var v24 = it.pm10Value24; if (v24 && v24!=='-'){ var n24=Number(v24); if (isFinite(n24)) byDate[d].v24 = n24; }
            var v1 = it.pm10Value;   if (v1 && v1!=='-'){ var n1=Number(v1); if (isFinite(n1)) byDate[d].vals.push(n1); }
          }
          // 날짜별 대표값 확정
          var dayMap = Object.create(null);
          Object.keys(byDate).forEach(function(d){
            var v = isFinite(byDate[d].v24) ? byDate[d].v24 : avg(byDate[d].vals);
            dayMap[d] = v;
          });
          seriesPerStation[name]=dayMap;
          return true;
        });
      }).then(function(){
        var set=Object.create(null);
        stationNames.forEach(function(name){
          var m=seriesPerStation[name]||{};
          for (var d in m) set[d]=1;
        });
        timeline=Object.keys(set).sort(); // YYYY-MM-DD
      });
    }

    function rebuildFeatures(coords, stationNames){
      vectorSrc.clear(); features=[];
      stationNames.forEach(function(name){
        var ll=coords[name]; if (!ll) return;
        var f=new ol.Feature({ geometry:new ol.geom.Point(ol.proj.fromLonLat(ll)), name:name, value:NaN });
        features.push(f);
      });
      vectorSrc.addFeatures(features);
      if (features.length){
        var tmp=new ol.source.Vector({ features:features });
        olMap.getView().fit(tmp.getExtent(), { padding:[40,40,40,40], maxZoom:11 });
      }
    }

    function renderFrame(i, fieldKey){
      if (!timeline.length) return;
      if (i<0 || i>=timeline.length) i=0; currentIdx=i;
      var d=timeline[i];
      tslabel.textContent = d + ' · ' + fieldKey;
      slider.max=Math.max(0, timeline.length-1);
      slider.value=i;

      for (var k=0;k<features.length;k++){
        var f=features[k], name=f.get('name');
        var m=seriesPerStation[name]||{};
        var v=m[d];
        f.set('value', (typeof v==='number') ? v : NaN);
      }
      vectorLyr.changed();
    }

    function play(){ if (timer||!timeline.length) return; timer=setInterval(function(){ var i=currentIdx+1; if (i>=timeline.length) i=0; renderFrame(i, fieldSel.value); }, 1000/FPS); }
    function pause(){ if (timer){ clearInterval(timer); timer=null; } }

    /* 이벤트 */
    btnLoad.addEventListener('click', function(){
      pause(); showLoading(true,'측정소/시계열 수집 중…');
      var sido=sidoSel.value, fieldKey=fieldSel.value; // fieldKey는 라벨만 표시용(계산은 위 규칙)
      loadStationCoords(sido).then(function(coordMap){
        var stationNames=Object.keys(coordMap); if (!stationNames.length) throw new Error('측정소 좌표가 없습니다.');
        return buildDailyTimelineAndSeries(stationNames, fieldKey).then(function(){
          rebuildFeatures(coordMap, stationNames);
          if (!timeline.length){ alert('표시할 데이터가 없습니다. (일 단위 타임라인이 비어 있음)'); return; }
          renderFrame(0, fieldKey);
        });
      }).catch(function(e){ console.error(e); alert('데이터 로드 실패: '+(e.message||e)); })
        .finally(function(){ showLoading(false); });
    });

    btnPlay.addEventListener('click', play);
    btnPause.addEventListener('click', pause);
    slider.addEventListener('input', function(){ pause(); renderFrame(Number(slider.value)||0, fieldSel.value); });

    (function init(){ document.getElementById('btnLoad').click(); })();
  </script>
</body>
</html>