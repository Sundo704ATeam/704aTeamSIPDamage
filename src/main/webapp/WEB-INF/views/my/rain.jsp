<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>
  <style>
    :root { --footer-h: 40px; --tool-w: 120px; }
    html, body { margin:0; height:100%; }
    #map {
      position: fixed;
      top: var(--header-h);
      left: var(--rail-w);
      right: 0;
      bottom: var(--footer-h);
    }
    footer {
      position: fixed; left:0; right:0; bottom:0; height:var(--footer-h);
      background: var(--gray-800); color:#fff;
      display:flex; align-items:center; justify-content:center;
      border-top:1px solid var(--gray-700);
      z-index:1000;
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
    
    #timelineDock{
      position: fixed; z-index: 960;
      left: calc(var(--rail-w, 60px) + var(--tool-w) + 12px);
      right: 12px; bottom: calc(var(--footer-h) + 8px);
      background:#ffffffee; border:1px solid #e5e7eb; border-radius:12px;
      padding:10px 12px; display:flex; align-items:center; gap:12px;
      backdrop-filter: blur(2px);
    }
    #slider{ flex:1; }
    
    #legend {
	    position: absolute;
	    top: calc(var(--header-h, 60px) + 12px);
	    right: 20px;
	    background: white;
	    border: 1px solid #ccc;
	    padding: 8px;
	    border-radius: 4px;
	    font-size: 10px;
	    line-height: 1;
	}
	.legend-item {
	    display: flex;
	    align-items: center;
	    gap: 5px;
	    margin: 0;
	    padding: 0;
	}
	.legend-color {
	    width: 10px;
	    height: 12px;
	    flex-shrink: 0;
	}
    
  </style>

</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>
  <aside id="dataRail">
	  <a href="#" id="rainToggle" aria-expanded="false" aria-controls="rainSub">강우량</a>
	  <div id="rainSub" class="subnav" role="region" aria-label="rain sub menu">
	    <a class="sub-link" href="${pageContext.request.contextPath}/rain">실시간 강우량</a>
	  </div>
	  
	  <!-- 황사 토글 버튼 -->
	  <a href="${pageContext.request.contextPath}/dust">황사</a>
  </aside>

  <div id="map"></div>
  
  <!-- 범례 -->
  <div id="legend">
	<div class="legend-item"><div class="legend-color" style="background-color:#000000;"></div><div>110</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#1a0b66;"></div><div>90</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#2b1a99;"></div><div>80</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#3c29cc;"></div><div>70</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#8a4ce5;"></div><div>60</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#b38aff;"></div><div>50</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#e6d4ff;"></div><div>40</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#f0d0d0;"></div><div>30</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ff4c4c;"></div><div>25</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ff6600;"></div><div>20</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ff8800;"></div><div>15</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ffaa00;"></div><div>10</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ffff00;"></div><div>9</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ffeb66;"></div><div>8</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#fff599;"></div><div>7</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#fffccc;"></div><div>6</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#ffffe0;"></div><div>5</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#00cc00;"></div><div>4</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#33d633;"></div><div>3</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#66e066;"></div><div>2</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#99ff99;"></div><div>1</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#3399ff;"></div><div>0.5</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#66b3ff;"></div><div>0.1</div></div>
	<div class="legend-item"><div class="legend-color" style="background-color:#99ccff;"></div><div>0</div></div>
  </div>
  
  <!-- === 슬라이드바 컨트롤 === -->
  <div id="timelineDock">
    <div id="pastlabel"><strong>현재</strong></div>
    <input id="slider" type="range" min="0" max="${fn:length(rainfalls)-1}" step="1" value="${fn:length(rainfalls)-1}" />
    <div id="tslabel"><strong>현재</strong></div>
  </div>
  
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>
  
  <script type="text/javascript">
	  (function(){
	      var btn = document.getElementById('rainToggle');
	      var sub = document.getElementById('rainSub');
	      if (!btn || !sub) return;
	
	      btn.addEventListener('click', function(e){
	        e.preventDefault();
	        var opened = sub.classList.toggle('open');
	        btn.setAttribute('aria-expanded', opened ? 'true' : 'false');
	      });
	
	      // 바깥을 클릭하면 접기 (선택사항)
	      document.addEventListener('click', function(e){
	        if (!sub.classList.contains('open')) return;
	        if (!e.target.closest('#rainToggle') && !e.target.closest('#rainSub')){
	          sub.classList.remove('open');
	          btn.setAttribute('aria-expanded', 'false');
	        }
	      });
	    })();
	  
		// ======== 1. JSTL 데이터 -> JS 배열 ========
	    const rainfalls = [
	      <c:forEach var="r" items="${rainfalls}" varStatus="st">
	        { gaugeCode:${r.gauge_code}, time:"${r.time}", rainfall:${r.rainfall} }<c:if test="${!st.last}">,</c:if>
	      </c:forEach>
	    ];
	    const gauges = [
	      <c:forEach var="g" items="${gauges}" varStatus="st">
	        { gaugeCode:${g.gauge_code}, lon:${g.longitude}, lat:${g.latitude}, location:"${g.location}" }<c:if test="${!st.last}">,</c:if>
	      </c:forEach>
	    ];

	    // ======== 2. 시간 배열 (과거 → 최신) ========
	    const times = [...new Set(rainfalls.map(r => r.time))]
                .sort((a, b) => new Date(a) - new Date(b));

	    const slider = document.getElementById('slider');
	    const tslabel = document.getElementById('tslabel');
	    const pastlabel = document.getElementById('pastlabel');
	    
	 	// 슬라이더 세팅
	    slider.min = 0;
	    slider.max = times.length - 1;
	    slider.value = times.length - 1; // 초기값: 최신(오른쪽 끝)
	    pastlabel.textContent = times[0];

	    // ======== 3. 지도 생성 ========
	    const vectorSource = new ol.source.Vector();
	    const vectorLayer = new ol.layer.Vector({ source: vectorSource });

	    const map = new ol.Map({
	      target: 'map',
	      layers: [
	        new ol.layer.Tile({ source: new ol.source.OSM() }),
	        vectorLayer
	      ],
	      view: new ol.View({
	        center: ol.proj.fromLonLat([126.95, 37.53]),
	        zoom: 11
	      })
	    });

	    // ======== 4. 색상 단계 ========
	    function getColor(val) {
		    if (val >= 110) return '#000000';
		    if (val >= 90) return '#1a0b66';
		    if (val >= 80) return '#2b1a99';
		    if (val >= 70) return '#3c29cc';
		    if (val >= 60) return '#8a4ce5';
		    if (val >= 50) return '#b38aff';
		    if (val >= 40) return '#e6d4ff';
		    if (val >= 30) return '#f0d0d0';
		    if (val >= 25) return '#ff4c4c';
		    if (val >= 20) return '#ff6600';
		    if (val >= 15) return '#ff8800';
		    if (val >= 10) return '#ffaa00';
		    if (val >= 9) return '#ffff00';
		    if (val >= 8) return '#ffeb66';
		    if (val >= 7) return '#fff599';
		    if (val >= 6) return '#fffccc';
		    if (val >= 5) return '#ffffe0';
		    if (val >= 4) return '#00cc00';
		    if (val >= 3) return '#33d633';
		    if (val >= 2) return '#66e066';
		    if (val >= 1) return '#99ff99';
		    if (val >= 0.5) return '#3399ff';
		    if (val >= 0.1) return '#66b3ff';
		    return '#99ccff';
		}

	    // ======== 5. 강우량 데이터 표시 ========
	    function updateRainfallDisplay(timeIndex){
	      const currentTime = times[timeIndex];
	      tslabel.textContent = currentTime;
	      vectorSource.clear();

	      const currentData = rainfalls.filter(r => r.time === currentTime);
	      currentData.forEach(rf => {
	        const gauge = gauges.find(g => g.gaugeCode === rf.gaugeCode);
	        if(!gauge) return;

	        const feature = new ol.Feature({
	          geometry: new ol.geom.Point(ol.proj.fromLonLat([gauge.lon, gauge.lat])),
	          rainfall: rf.rainfall
	        });

	        feature.setStyle(new ol.style.Style({
	          image: new ol.style.Circle({
	            radius: 13,
	            fill: new ol.style.Fill({ color: getColor(rf.rainfall) }),
	          	stroke: null
	          }),
	          text: new ol.style.Text({
	            text: rf.rainfall.toFixed(1),
	            fill: new ol.style.Fill({ color:'#000' }),
	            stroke: new ol.style.Stroke({ color:'#fff', width:2 }),
	            font: 'bold 12px sans-serif'
	          })
	        }));

	        vectorSource.addFeature(feature);
	      });
	    }

	 	// ===== 초기 표시 =====
	    updateRainfallDisplay(slider.value);
	 
	    // ======== 6. 슬라이더 이벤트 ========
	    slider.addEventListener('input', e => {
	        const idx = parseInt(e.target.value);
	        updateRainfallDisplay(idx); // idx=0 → 2주전, idx=max → 최신
	    });

  </script>
</body>
</html>