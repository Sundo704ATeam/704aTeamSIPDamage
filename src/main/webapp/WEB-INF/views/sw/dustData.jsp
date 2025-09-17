<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>권역별 1주일 미세먼지 데이터</title>
  <style>
    :root {
      --header-h: 60px;
      --footer-h: 40px;
      --rail-w: 60px;
      --tool-w: 120px;
      --legend-bottom: 140px;
      --zoom-x: -16px;
      --zoom-gap: 16px;
    }
    html, body { margin:0; height:100%; }
    #map { width:100%; height:calc(100vh - var(--footer-h)); }

    /* ===== 상단 컨트롤 패널 ===== */
    #controlPanel {
      position: fixed; z-index: 2000;
      top: calc(var(--header-h) + 10px);
      left: calc(var(--rail-w) + var(--tool-w) + 20px);
      display:flex; align-items:center; gap:10px;
      padding: 8px 12px;
      background: rgba(255,255,255,.95);
      border: 1px solid #ddd;
      border-radius: 8px;
      width: fit-content;
    }
    #controlPanel select, #controlPanel button {
      font-size: 13px;
      padding: 4px 6px;
    }

    /* ===== 하단 트랙바 ===== */
    #trackbarContainer {
      position: fixed; z-index: 2000;
      bottom: 60px;
      left: calc(var(--rail-w) + var(--tool-w) + 20px);
      right: 20px;
      background: rgba(255,255,255,.95);
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 6px 12px;
    }
    #trackbarControls {
      display: flex; align-items: center; gap: 6px;
    }
    #trackbarContainer button {
      width:34px; height:34px;
      border:1px solid #ccc; border-radius:6px;
      background:#fff; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
      font-size:16px;
    }
    #trackbar { flex: 1; }
    #timeLabel { font-size: 13px; color: #111; min-width: 150px; text-align:right; }

    /* ===== 팝업 ===== */
    .ol-popup {
      position:absolute; background:#fff; border:1px solid #ccc;
      min-width:260px; font-size:13px;
      box-shadow:0 2px 6px rgba(0,0,0,0.3); border-radius:6px;
    }
    .ol-popup #popup-closer {
      position:absolute;
      top:6px; right:8px;
      text-decoration:none;
      font-size:14px;
      color:#666;
      cursor:pointer;
    }
    .ol-popup #popup-closer:hover {
      color:#000;
    }
    .ol-popup #popup-content {
      padding:12px 14px;
    }

    /* ===== 범례 + 줌 ===== */
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
      width:30px; height:30px; border:1px solid #ccc; background:#fff;
      border-radius:4px; font-size:16px; font-weight:bold; cursor:pointer;
    }
    #legendRow {
      display: flex;
      flex-direction: row;   /* 바 + 숫자 나란히 */
      align-items: center;
      gap: 6px;
      margin-top: 6px;
    }
    #legendBar {
      width: 30px; height: 220px;
      background: linear-gradient(to top, #00B050 0%, #FFFF00 40%, #FF9900 70%, #FF0000 100%);
      border: 1px solid #ccc; border-radius: 6px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    }
    #legendLabels {
      display:flex; flex-direction:column; justify-content:space-between;
      height:220px; font-size:11px; color:#000;
    }

    footer {
      position:fixed; bottom:0; left:0; right:0; height:var(--footer-h);
      background:#1f2937; color:#fff; display:flex; align-items:center; justify-content:center;
      font-size:13px; z-index:2100;
    }
  </style>
</head>
<body>
  <%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/sidebar.jsp" %>
  <%@ include file="/WEB-INF/views/sisidebar.jsp" %>

  <!-- 상단 컨트롤 -->
  <div id="controlPanel">
    <select id="sidoSelect">
      <option value="서울">서울</option><option value="부산">부산</option>
      <option value="대구">대구</option><option value="인천">인천</option>
      <option value="광주">광주</option><option value="대전">대전</option>
      <option value="울산">울산</option><option value="세종">세종</option>
      <option value="경기">경기</option><option value="강원">강원</option>
      <option value="충북">충북</option><option value="충남">충남</option>
      <option value="전북">전북</option><option value="전남">전남</option>
      <option value="경북">경북</option><option value="경남">경남</option>
      <option value="제주">제주</option>
    </select>
    <select id="pollutantSelect">
      <option value="pm10">PM10</option>
      <option value="pm2_5">PM2.5</option>
    </select>
    <button id="btnFetch" class="btn btn-sm btn-primary"><i class="bi bi-search"></i> 조회</button>
  </div>

  <!-- 하단 트랙바 -->
  <div id="trackbarContainer">
    <div id="trackbarControls">
      <button id="btnFirst"><i class="bi bi-skip-start-fill"></i></button>
      <button id="btnPrev"><i class="bi bi-caret-left-fill"></i></button>
      <button id="btnPlayPause"><i class="bi bi-play-fill"></i></button>
      <button id="btnNext"><i class="bi bi-caret-right-fill"></i></button>
      <button id="btnLast"><i class="bi bi-skip-end-fill"></i></button>
      <input type="range" id="trackbar" min="0" max="0" step="1" value="0">
      <div id="timeLabel">시각: -</div>
    </div>
  </div>

  <!-- 지도 -->
  <div id="map"></div>

  <!-- 우측 범례/줌 -->
  <div id="legendContainer">
    <div id="zoomControls">
      <button id="zoomIn">+</button>
      <button id="zoomOut">−</button>
    </div>
    <div id="legendRow">
      <div id="legendBar"></div>
      <div id="legendLabels"><span>200+</span><span>150</span><span>80</span><span>30</span><span>0</span></div>
    </div>
  </div>

  <!-- 팝업 -->
  <div id="popup" class="ol-popup">
    <a href="#" id="popup-closer">✖</a>
    <div id="popup-content"></div>
  </div>

  <script>
    // ===== 기본 지도 =====
    const map = new ol.Map({
      target:"map",
      layers:[new ol.layer.Tile({
        source:new ol.source.XYZ({
          url:"http://api.vworld.kr/req/wmts/1.0.0/60DA3367-BC75-32D9-B593-D0386112A70C/Base/{z}/{y}/{x}.png"
        })
      })],
      view:new ol.View({center:ol.proj.fromLonLat([127.0246,37.5326]),zoom:11.2,minZoom:6,maxZoom:19})
    });

    // ===== 팝업 =====
    const overlay=new ol.Overlay({element:document.getElementById("popup"),autoPan:true,autoPanAnimation:{duration:250}});
    map.addOverlay(overlay);
    document.getElementById("popup-closer").onclick=()=>{overlay.setPosition(undefined);return false;};
    function closePopup(){ overlay.setPosition(undefined); }

    // ===== 시도 중심 좌표 =====
    const sidoCenters={ 
      "서울":[126.9780,37.5665],"부산":[129.0756,35.1796],"대구":[128.6014,35.8714],
      "인천":[126.7052,37.4563],"광주":[126.8514,35.1605],"대전":[127.3845,36.3504],
      "울산":[129.3114,35.5393],"세종":[127.2890,36.4800],"경기":[127.5183,37.4138],
      "강원":[128.1555,37.8228],"충북":[127.4913,36.6357],"충남":[126.8,36.5184],
      "전북":[127.1088,35.7175],"전남":[126.4630,34.8161],"경북":[128.8889,36.4919],
      "경남":[128.6919,35.2372],"제주":[126.5312,33.4996] 
    };

    // ===== 임계값 (범례) =====
    const thresholds = { pm10: [0, 30, 80, 150, "200+"], pm2_5: [0, 15, 35, 75, "150+"] };
    function getPmColor(pollutant, value){
      if(!value||value==='-')return "gray";
      const v=Number(value);
      if(pollutant==="pm10"){
        if(v<=30)return "#00B050"; if(v<=80)return "#FFFF00"; if(v<=150)return "#FF9900"; return "#FF0000";
      } else {
        if(v<=15)return "#00B050"; if(v<=35)return "#FFFF00"; if(v<=75)return "#FF9900"; return "#FF0000";
      }
    }
    function updateLegend(pollutant){
      const labels=document.querySelectorAll("#legendLabels span");
      const vals=thresholds[pollutant];
      for(let i=0;i<labels.length;i++){ labels[i].textContent=vals[vals.length-1-i]; }
    }

    const stationAddrMap = {
      <c:forEach var="s" items="${getDustStation}" varStatus="loop">
        "${s.stationName}": "${s.stationAddr}"<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
    };

    let dustRows=[<c:forEach var="r" items="${getDustMeasurements}" varStatus="loop">{
      stationName:"${r.stationName}", addr: stationAddrMap["${r.stationName}"] || "",
      dataTime:"${r.measureTime}", pm10:"${r.pm10}", pm2_5:"${r.pm2_5}", lon:${r.lon}, lat:${r.lat}
    }<c:if test="${!loop.last}">,</c:if></c:forEach>];

    let currentPollutant="pm10";
    document.getElementById("pollutantSelect").addEventListener("change",e=>{
      currentPollutant=e.target.value;
      updateLegend(currentPollutant);
      stationLayer.changed();
      updateAtIndex(parseInt(trackbar.value)||0);
      closePopup();
    });

    const stationLayer=new ol.layer.Vector({
      source:new ol.source.Vector(),
      style:f=>{
        const val=f.get(currentPollutant);
        return new ol.style.Style({
          image:new ol.style.Circle({radius:7,fill:new ol.style.Fill({color:getPmColor(currentPollutant,val)}),stroke:new ol.style.Stroke({color:"#fff",width:2})}),
          text:new ol.style.Text({text:val?String(val):"-",offsetY:-15,font:"bold 11px Noto Sans KR",fill:new ol.style.Fill({color:"#111"}),stroke:new ol.style.Stroke({color:"#fff",width:3})})
        });
      }
    });
    map.addLayer(stationLayer);

    map.on("singleclick",evt=>{
      const hit=map.getFeaturesAtPixel(evt.pixel);
      if(hit&&hit.length){const p=hit[0].getProperties();
        document.getElementById("popup-content").innerHTML=
          "<b>측정소명: "+(p.name||'-')+"</b><br/>주소: "+(p.addr||'-')+"<br/>PM10: "+(p.pm10||'-')+"<br/>PM2.5: "+(p.pm2_5||'-')+"<br/>시간: "+(p.time||'-');
        overlay.setPosition(evt.coordinate);
      } else closePopup();
    });

    let times=[],rowsByTime={};
    const trackbar=document.getElementById("trackbar"),timeLabel=document.getElementById("timeLabel");
    function formatKST(d){const pad=n=>String(n).padStart(2,"0"); return d.getFullYear()+"-"+pad(d.getMonth()+1)+"-"+pad(d.getDate())+" "+pad(d.getHours())+":"+pad(d.getMinutes());}
    function rebuildIndex(){
      const set=new Set(); rowsByTime={};
      for(const row of dustRows){ const d=new Date(row.dataTime); if(d.getMinutes()!==0) continue;
        const hourStr=formatKST(d); set.add(hourStr);
        if(!rowsByTime[hourStr]) rowsByTime[hourStr]=[]; rowsByTime[hourStr].push(row);
      }
      times=Array.from(set).sort((a,b)=>new Date(a)-new Date(b));
      trackbar.min=0; trackbar.max=Math.max(times.length-1,0); trackbar.value=trackbar.max;
      updateAtIndex(Number(trackbar.value));
    }
    function renderAt(timeStr){const src=stationLayer.getSource(); src.clear();
      const feats=[]; (rowsByTime[timeStr]||[]).forEach(r=>{
        if(r.lon&&r.lat)feats.push(new ol.Feature({geometry:new ol.geom.Point(ol.proj.fromLonLat([Number(r.lon),Number(r.lat)])), name:r.stationName, addr:r.addr, pm10:r.pm10, pm2_5:r.pm2_5, time:timeStr }));
      });
      src.addFeatures(feats);
    }
    function updateAtIndex(idx){ if(!times.length){timeLabel.textContent="시각: -"; stationLayer.getSource().clear(); return;}
      const t=times[idx]; timeLabel.textContent="시각: "+t; renderAt(t);}
    rebuildIndex();

    // ===== 재생 컨트롤 =====
    let playInterval=null;
    const btnPlayPause=document.getElementById("btnPlayPause");
    const playIcon='<i class="bi bi-play-fill"></i>';
    const pauseIcon='<i class="bi bi-pause-fill"></i>';
    function stopPlayback(){ if(playInterval){ clearInterval(playInterval); playInterval=null; btnPlayPause.innerHTML=playIcon; } }

    btnPlayPause.onclick=()=>{ if(playInterval){ stopPlayback(); } else { btnPlayPause.innerHTML=pauseIcon; playInterval=setInterval(()=>{ let v=parseInt(trackbar.value||"0",10); if(v<times.length-1){ v++; trackbar.value=v; updateAtIndex(v);} else { stopPlayback(); } closePopup(); },1000);} };

    // 버튼/슬라이더 이벤트
    document.getElementById("btnFirst").onclick=()=>{stopPlayback();trackbar.value=0;updateAtIndex(0);closePopup();};
    document.getElementById("btnLast").onclick=()=>{stopPlayback();trackbar.value=times.length-1;updateAtIndex(times.length-1);closePopup();};
    document.getElementById("btnPrev").onclick=()=>{stopPlayback();let v=Math.max(0,parseInt(trackbar.value||"0",10)-1);trackbar.value=v;updateAtIndex(v);closePopup();};
    document.getElementById("btnNext").onclick=()=>{stopPlayback();let v=Math.min(times.length-1,parseInt(trackbar.value||"0",10)+1);trackbar.value=v;updateAtIndex(v);closePopup();};
    trackbar.addEventListener("input",()=>{stopPlayback();updateAtIndex(parseInt(trackbar.value||"0",10));closePopup();});

    document.getElementById("btnFetch").onclick=()=>{closePopup();
      const sido=document.getElementById("sidoSelect").value;
      if(sidoCenters[sido]){ let zoomLevel=11; if(["경기","강원","충북","충남","전북","경북"].includes(sido)){zoomLevel=10;}
        map.getView().animate({center:ol.proj.fromLonLat(sidoCenters[sido]),zoom:zoomLevel,duration:800}); }
      $.get("${pageContext.request.contextPath}/dustMeasurements",{sido},data=>{
        dustRows=(data||[]).map(d=>({ stationName:d.stationName, addr:stationAddrMap[d.stationName]||"", dataTime:d.dataTime, pm10:d.pm10, pm2_5:d.pm2_5, lon:d.dmX, lat:d.dmY }));
        rebuildIndex();
      });
    };

    document.getElementById("zoomIn").onclick=()=>{map.getView().setZoom(map.getView().getZoom()+1);closePopup();};
    document.getElementById("zoomOut").onclick=()=>{map.getView().setZoom(map.getView().getZoom()-1);closePopup();};

    updateLegend(currentPollutant);
  </script>

  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>
</body>
</html>
