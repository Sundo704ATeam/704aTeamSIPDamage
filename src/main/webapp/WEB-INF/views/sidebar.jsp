<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
  .rail{
    position:fixed; z-index:950;
    top:var(--header-h); left:0; bottom:0; width:var(--rail-w);
    background: var(--gray-700); color:#fff;
    display:flex; flex-direction:column; gap:8px; padding:16px 10px;
    overflow: hidden; /* 좌우 스크롤 안 뜨게 */
  }

  .menu-item{
    display:block;
    padding:10px 12px;
    border-radius:10px;
    text-decoration:none;
    color:#fff;
    background: transparent;
    /* 글씨 안 짤리게: 좌측 정렬 + 줄바꿈 허용 */
    text-align:left;
    white-space: normal;      /* 줄바꿈 허용 */
    word-break: keep-all;     /* 한국어 단어 중간 분절 방지 */
    line-height: 1.3;
    font-size: 14px;
  }
  .menu-item:hover{ background: rgba(0,0,0,.15); }
  .menu-item.active{
    background: var(--gray-800);
    font-weight:700;
    border:1px solid rgba(255,255,255,.08);
  }
</style>


<nav id="leftRail" class="rail">
  <a class="menu-item" href="${pageContext.request.contextPath}/">HOME</a>
  <a class="menu-item" href="${pageContext.request.contextPath}/damageMap">노후화 패턴분석</a>
  <a class="menu-item" href="${pageContext.request.contextPath}/diagnose">건물상세</a>
  <a class="menu-item" href="${pageContext.request.contextPath}/dust">손상진단 시뮬</a>
</nav>

