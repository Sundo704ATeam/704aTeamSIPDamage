<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>사회기반시설 스마트 유지관리 시스템 - 황사/미세먼지 예보</title>
  <style>
    :root{
      --footer-h: 40px;
      --tool-w: 120px;   /* 좌측 기본 레일 폭 (sidebar.jsp) */
      --fcst-w: 360px;   /* 보조 사이드바 폭 */
    }
    html, body{
      margin:0; height:100%; background:#f7f7f7;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, 'Noto Sans KR', sans-serif;
    }

    /* ===== 좌측 기본 레일 (sidebar.jsp 톤과 유사한 회색계열) ===== */
    #dataRail{
      position: fixed; z-index: 900;
      top: var(--header-h, 60px); left: var(--rail-w, 60px);
      bottom: var(--footer-h, 40px);
      width: var(--tool-w); background:#f3f3f3;
      border-right:1px solid #ddd;
      padding:12px 10px; display:flex; flex-direction:column; gap:8px;
    }
    #dataRail a{
      display:block; width:100%; padding:10px 12px;
      text-align:center; border-radius:10px;
      text-decoration:none; border:1px solid #6b7280; /* gray-500 */
      background:#fff; color:#111;
    }
    #dataRail a:hover{ background:#e5e7eb; }

    /* 드롭다운(아코디언) */
    #dataRail .rail-link{
      display:flex; align-items:center; justify-content:space-between;
      width:100%; padding:10px 12px; text-align:left; border-radius:10px;
      border:1px solid #6b7280; background:#fff; color:#111; cursor:pointer;
    }
    #dataRail .rail-link:hover{ background:#e5e7eb; }
    #dataRail .caret{
      width:0; height:0; margin-left:8px;
      border-left:5px solid transparent; border-right:5px solid transparent;
      border-top:6px solid #4b5563; /* gray-600 */
      transition: transform .2s ease;
    }
    #dataRail .rail-link[aria-expanded="true"] .caret{ transform: rotate(180deg); }

    #dataRail .submenu{
      overflow:hidden; max-height:0; transition:max-height .2s ease;
    }
    #dataRail .submenu.open{ margin-top:4px; }
    #dataRail .sub-link{
      display:block; padding:8px 10px; margin:4px 0 0 6px; font-size:13px;
      border-radius:8px; border:1px dashed #cbd5e1; background:#fff; color:#111; text-decoration:none;
    }
    #dataRail .sub-link:hover{ background:#f3f4f6; }

    /* ===== 보조 사이드바(권역 칩/표) – 중립 회색 UI ===== */
    #fcstRail{
      position: fixed; z-index: 890;
      top: var(--header-h, 60px);
      left: calc(var(--rail-w, 60px) + var(--tool-w));
      bottom: var(--footer-h, 40px);
      width: var(--fcst-w);
      background:#fff; border-right:1px solid #e5e7eb;
      padding:12px; overflow:auto;
    }
    #fcstRail h3{ margin:0 0 8px; font-size:15px; color:#111; }
    #gradesChips{ display:flex; flex-wrap:wrap; gap:6px; }
    .chip{
      display:inline-flex; align-items:center; gap:6px;
      padding:6px 10px; border-radius:999px;
      border:1px solid #e5e7eb; background:#fff; font-size:12px; color:#111;
    }
    .dot{ width:10px; height:10px; border-radius:50%; border:1px solid #cbd5e1; }
    table{ width:100%; border-collapse:collapse; font-size:13px; }
    th, td{ padding:8px 10px; border-bottom:1px solid #eee; }
    th{ text-align:left; background:#fafafa; color:#475569; position:sticky; top:0; }

    /* ===== 메인 패널(이미지/컨트롤) – 회색계열 버튼 ===== */
    #panel{
      position: fixed; z-index: 1;
      top: var(--header-h, 60px);
      left: calc(var(--rail-w, 60px) + var(--tool-w) + var(--fcst-w));
      right: 0;
      bottom: var(--footer-h, 40px);
      padding:12px;
      display:grid; grid-template-rows:auto 1fr auto; gap:12px;
    }
    #toolbar{
      background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:10px 12px;
      display:flex; gap:8px; align-items:center; position:sticky; top:0; z-index:2;
    }
    #toolbar > *{ flex:0 0 auto; }
    #toolbar .grow{ flex:1 1 auto; }
    select, input[type="date"], button{
      padding:10px 12px; border-radius:10px; border:1px solid #cbd5e1; background:#fff; color:#111;
    }
    .btn-primary{
      background:#4b5563; border-color:#4b5563; color:#fff;  /* ← 갈색 제거, 회색 버튼 */
    }
    .btn-primary:hover{ filter:brightness(0.95); }

    #images{
      background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:12px; overflow:auto;
    }
    #hero{ width:100%; max-height:60vh; object-fit:contain; background:#fff; border:1px solid #d1d5db; border-radius:10px; }
    #thumbs{ display:flex; gap:8px; overflow:auto; padding-top:8px; }
    #thumbs img{ width:120px; height:80px; object-fit:cover; border:1px solid #d1d5db; border-radius:8px; cursor:pointer; }
    #noImageTip{ display:none; font-size:12px; color:#64748b; margin-top:6px; }

    #meta{
      background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:10px 12px;
      font-size:13px; color:#334155;
    }
    #meta h4{ margin:0 0 6px; font-size:14px; color:#111; }

    /* 로딩 */
    #loading{
      position: fixed; z-index: 3;
      left:50%; top: calc(var(--header-h, 60px) + 12px); transform: translateX(-50%);
      background:#ffffffdd; border:1px solid #d1d5db; border-radius:10px; padding:8px 12px; font-size:13px; color:#111;
    }

    footer{
      position: fixed; left:0; right:0; bottom:0; height: var(--footer-h);
      background:#333; color:#fff; display:flex; align-items:center; justify-content:center;
      border-top:1px solid #444; z-index:1000;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <!-- 좌측 기본 레일 + 드롭다운 -->
  <aside id="dataRail" role="navigation" aria-label="기능 메뉴">
    <a class="rail-link" href="${pageContext.request.contextPath}/rain">강우량</a>

    <button type="button" class="rail-link" id="dustToggle"
            aria-expanded="false" aria-controls="dustSub">
      황사 <span class="caret" aria-hidden="true"></span>
    </button>

    <div id="dustSub" class="submenu" role="region" aria-label="황사 하위 메뉴">
      <a class="sub-link" href="${pageContext.request.contextPath}/dust">실시간 PM10 측정정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dust24">PM10 예측정보</a>
      <a class="sub-link" href="${pageContext.request.contextPath}/dustTest">측정소 3개월 타임라인</a>
    </div>
  </aside>

  <!-- 보조 사이드바: 권역 칩/표 (화이트 + 그레이만 사용) -->
  <aside id="fcstRail" aria-label="권역 등급 목록">
    <h3>권역별 등급</h3>
    <div id="gradesChips" style="margin-bottom:10px;"></div>
    <table id="gradesTable">
      <thead><tr><th style="width:46%;">권역</th><th>등급</th></tr></thead>
      <tbody></tbody>
    </table>
  </aside>

  <!-- 메인: 컨트롤 + 이미지 + 원인/행동요령 -->
  <section id="panel">
    <div id="toolbar">
      <input type="date" id="searchDate"/>
      <select id="informCode">
        <option value="PM10" selected>PM10</option>
        <option value="PM25">PM2.5</option>
        <option value="O3">오존(O₃)</option>
      </select>
      <div class="grow"></div>
      <button id="btnFetch" class="btn-primary">조회</button>
    </div>

    <div id="images">
      <img id="hero" alt="예측 이미지"/>
      <div id="thumbs"></div>
      <div id="noImageTip">해당 항목/발표시각에 제공된 예측 이미지가 없습니다. (PM10/PM2.5는 간혹 이미지가 생략됩니다)</div>
    </div>

    <div id="meta">
      <h4>원인 · 행동요령</h4>
      <div id="cause" style="margin-bottom:6px;"></div>
      <div id="action"></div>
      <div style="margin-top:8px; font-size:12px; color:#64748b;">
        <span>발표시각: <span id="dataTime">-</span></span> ·
        <span>예보대상일: <span id="informData">-</span></span>
      </div>
    </div>
  </section>

  <div id="loading" hidden>예보 데이터 조회 중…</div>
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>

  <script>
    /* ===== 좌측 드롭다운 ===== */
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
      if (/(\/dust24|\/dust)(\/)?$/.test(location.pathname)) setOpen(true);
      window.addEventListener('resize', function(){
        if (sub.classList.contains('open')) sub.style.maxHeight = sub.scrollHeight + 'px';
      });
    })();

    /* ===== 예보 API ===== */
    var SERVICE_KEY = '618d2c5b94a2d50f226246011a65cfbd793aefab6972a7408e4e15236bb33ad6';
    var BASE_FCST   = 'https://apis.data.go.kr/B552584/ArpltnInforInqireSvc';
    var PATH_FCST   = '/getMinuDustFrcstDspth';
    var LOCAL_PROXY = '${pageContext.request.contextPath}/proxy.jsp';

    function fetchTextViaLocalProxy(url){
      return fetch(LOCAL_PROXY + '?url=' + encodeURIComponent(url))
        .then(function(res){ if(!res.ok) throw new Error('HTTP '+res.status); return res.text(); });
    }
    function tryParseJSON(t){ try { return JSON.parse(t); } catch(e){ return null; } }
    function parseXML(t){ return (new DOMParser()).parseFromString(t, 'text/xml'); }

    // 상태색은 칩의 '점(dot)'에만 사용하고 배경은 회색계열 유지
    function dotColor(g){
      if (!g) return '#cbd5e1';
      if (g.indexOf('매우나쁨')>-1) return '#ef4444';
      if (g.indexOf('나쁨')>-1)     return '#f97316';
      if (g.indexOf('보통')>-1)     return '#eab308';
      if (g.indexOf('좋음')>-1)     return '#60a5fa';
      return '#cbd5e1';
    }

    function parseInformGrade(str){
      if (!str) return [];
      return str.split(',').map(function(s){ return s.trim(); }).filter(Boolean).map(function(pair){
        var sp = pair.split(':'); if (sp.length < 2) sp = pair.split(' : ');
        return { area:(sp[0]||'').trim(), grade:(sp[1]||'').trim() };
      }).filter(function(o){ return o.area && o.grade; });
    }

    function collectImagesFromItem(item){
      var set = Object.create(null), out=[];
      for (var i=1;i<=9;i++){
        var k='imageUrl'+i, u=item[k];
        if (u && !set[u]){ set[u]=1; out.push(u); }
      }
      return out;
    }

    var searchDate = document.getElementById('searchDate');
    var informCode = document.getElementById('informCode');
    var btnFetch   = document.getElementById('btnFetch');

    var chipsEl  = document.getElementById('gradesChips');
    var tableTbody = document.querySelector('#gradesTable tbody');

    var heroEl   = document.getElementById('hero');
    var thumbsEl = document.getElementById('thumbs');
    var noImageTip = document.getElementById('noImageTip');

    var causeEl  = document.getElementById('cause');
    var actionEl = document.getElementById('action');
    var dataTimeEl = document.getElementById('dataTime');
    var informDataEl = document.getElementById('informData');

    var loadingEl = document.getElementById('loading');

    function setToday(){
      var d=new Date(), y=d.getFullYear(), m=String(d.getMonth()+1).padStart(2,'0'), dd=String(d.getDate()).padStart(2,'0');
      searchDate.value = y+'-'+m+'-'+dd;
    }
    function showLoading(b, msg){ loadingEl.hidden = !b; if(msg) loadingEl.textContent = msg; }

    function buildUrl(dateStr, code){
      var qs = new URLSearchParams({
        serviceKey: SERVICE_KEY,
        returnType: 'json',
        searchDate: dateStr,
        informCode: code,
        ver: '1.1'
      }).toString();
      return BASE_FCST + PATH_FCST + '?' + qs;
    }

    function renderGrades(informGrade){
      chipsEl.innerHTML = ''; tableTbody.innerHTML = '';
      var arr = parseInformGrade(informGrade || '');
      if (!arr.length){
        var none = document.createElement('div');
        none.textContent = '권역 등급 정보가 없습니다.';
        none.style.color='#64748b'; none.style.fontSize='12px';
        chipsEl.appendChild(none);
        return;
      }
      // 칩
      arr.forEach(function(o){
        var chip = document.createElement('div');
        chip.className = 'chip';
        chip.innerHTML =
          '<span class="dot" style="background:'+dotColor(o.grade)+'"></span>' +
          '<strong>'+o.area+'</strong> ' + o.grade;
        chipsEl.appendChild(chip);

        // 표
        var tr = document.createElement('tr');
        var td1 = document.createElement('td'); td1.textContent = o.area;
        var td2 = document.createElement('td');
        td2.innerHTML = '<span class="dot" style="background:'+dotColor(o.grade)+';margin-right:6px;"></span>' + o.grade;
        tr.appendChild(td1); tr.appendChild(td2);
        tableTbody.appendChild(tr);
      });
    }

    function renderImages(item){
      var images = collectImagesFromItem(item);
      thumbsEl.innerHTML = '';
      if (images.length){
        noImageTip.style.display='none';
        var hero = images.find(function(u){ return /gif|ani/i.test(u); }) || images[0];
        heroEl.src = hero;
        images.forEach(function(u){
          var im = document.createElement('img');
          im.src = u;
          im.addEventListener('click', function(){ heroEl.src = u; });
          thumbsEl.appendChild(im);
        });
      } else {
        heroEl.removeAttribute('src');
        noImageTip.style.display='block';
      }
    }

    function renderMeta(item){
      causeEl.textContent   = item.informCause || '-';
      actionEl.textContent  = item.actionKnack || '-';
      dataTimeEl.textContent= item.dataTime || '-';
      informDataEl.textContent = item.informData || '-';
    }

    function fetchForecast(dateStr, code){
      var url = buildUrl(dateStr, code);
      showLoading(true, '예보 데이터 조회 중…');
      return fetchTextViaLocalProxy(url).then(function(txt){
        var j = tryParseJSON(txt);
        if (j && j.response && j.response.header && j.response.header.resultCode){
          var rc = j.response.header.resultCode;
          if (rc !== '00') throw new Error('API 오류: '+rc+' / '+(j.response.header.resultMsg||''));
        }
        var items = (j && j.response && j.response.body && j.response.body.items) ? j.response.body.items : null;

        if (!items){
          var xml = parseXML(txt);
          var err = xml.querySelector('OpenAPI_ServiceResponse');
          if (err){
            var code = (xml.querySelector('returnReasonCode')||{}).textContent || 'UNKNOWN';
            var msg  = (xml.querySelector('returnAuthMsg')||{}).textContent
                    || (xml.querySelector('returnReasonMsg')||{}).textContent || 'API error';
            throw new Error('API 오류: '+code+' / '+msg);
          }
          items = [];
          var list = xml.getElementsByTagName('item');
          for (var i=0;i<list.length;i++){
            var it = list[i]; function g(t){ var n=it.getElementsByTagName(t)[0]; return n?n.textContent:''; }
            var obj = {
              dataTime: g('dataTime'),
              informCode: g('informCode'),
              informData: g('informData'),
              informGrade: g('informGrade'),
              informCause: g('informCause'),
              actionKnack: g('actionKnack')
            };
            for (var k=1;k<=9;k++){ var key='imageUrl'+k; obj[key]=g(key); }
            items.push(obj);
          }
        }

        // 요청한 informCode로 필터
        var codeUpper = String(code).toUpperCase();
        var filtered = items.filter(function(it){
          return String(it.informCode || it.InformCode || '').toUpperCase() === codeUpper;
        });
        if (!filtered.length) filtered = items || [];
        filtered.sort(function(a,b){ return new Date(a.dataTime) - new Date(b.dataTime); });
        return filtered[filtered.length-1] || null;
      }).finally(function(){ showLoading(false); });
    }

    document.getElementById('btnFetch').addEventListener('click', function(){
      var d = searchDate.value;
      var c = informCode.value || 'PM10';
      if (!d){ alert('날짜를 선택하세요.'); return; }
      fetchForecast(d, c).then(function(item){
        if (!item){
          renderGrades('');
          heroEl.removeAttribute('src'); thumbsEl.innerHTML=''; noImageTip.style.display='block';
          renderMeta({});
          alert('예보 데이터가 없습니다. 날짜를 바꾸거나 나중에 다시 시도하세요.');
          return;
        }
        renderGrades(item.informGrade);
        renderImages(item);
        renderMeta(item);
      }).catch(function(e){
        console.error(e);
        alert('조회 실패: ' + (e.message || e));
      });
    });

    (function init(){
      setToday();
      document.getElementById('btnFetch').click();
    })();
  </script>
</body>
</html>
