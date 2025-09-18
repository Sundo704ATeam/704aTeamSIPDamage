<%@ page contentType="text/html;charset=UTF-8" %>
<style>
  /* ===== 데이터 레일 ===== */
  #dataRail {
    position: fixed; z-index: 900;
    top: var(--header-h, 60px);
    left: var(--rail-w, 60px);
    bottom: var(--footer-h, 40px);
    width: var(--tool-w, 120px);
    background:#fff;
    border-right:1px solid #ddd;
    padding:14px 10px;
    display:flex; flex-direction:column; gap:4px;
    font-size:14px;
  }

  /* 메인 메뉴 (심플 버튼) */
  #dataRail .rail-link {
    background:none;
    border:none;
    padding:8px 6px;
    text-align:left;
    font-weight:600;
    color:#333;
    cursor:pointer;
    display:flex; justify-content:space-between; align-items:center;
    transition: color .2s;
  }
  #dataRail .rail-link:hover {
    color:#2563eb;
  }

  /* 화살표 아이콘 */
  #dataRail .caret {
    margin-left:6px;
    border: solid #666;
    border-width: 0 2px 2px 0;
    display:inline-block;
    padding:3px;
    transform: rotate(45deg);
    transition: transform .2s;
  }
  #dataRail .rail-link[aria-expanded="true"] .caret {
    transform: rotate(-135deg);
  }

  /* 하위 메뉴 */
  #dataRail .submenu {
    margin-left:8px;
    border-left:2px solid #e5e7eb;
    padding-left:8px;
    display:flex; flex-direction:column; gap:4px;
  }
  #dataRail .sub-link {
    padding:6px 4px;
    font-size:13px;
    color:#555;
    text-decoration:none;
    border-radius:4px;
    transition: background .2s, color .2s;
  }
  #dataRail .sub-link:hover {
    background:#f3f4f6;
    color:#111;
  }
</style>

<aside id="dataRail">
  <a class="rail-link" href="${pageContext.request.contextPath}/rain">강우량</a>
  <button type="button" class="rail-link" id="dustToggle" aria-expanded="false" aria-controls="dustSub">
    황사 <span class="caret" aria-hidden="true"></span>
  </button>
  <div id="dustSub" class="submenu">
    <a class="sub-link" href="${pageContext.request.contextPath}/realTimeDust">실시간 PM10/PM2.5 정보</a>
    <a class="sub-link" href="${pageContext.request.contextPath}/dustData">권역별 1주일 데이터</a>
    <a class="sub-link" href="${pageContext.request.contextPath}/dustForecast">PM10/PM2.5 예보</a>
  </div>
</aside>
