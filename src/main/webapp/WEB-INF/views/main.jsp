<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>
  <style>
    :root { --footer-h: 40px; }
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
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>
  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>
</body>
</html>
