<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>OpenLayers 테스트</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="margin:0; display:flex; flex-direction:column; height:100vh;">

  <!-- 상단 헤더 -->
  <jsp:include page="/WEB-INF/views/header.jsp"/>

  <!-- 본문: 사이드바 + 지도 -->
  <div style="flex:1; display:flex; flex-direction:row;">
    <!-- 좌측 사이드바 -->
    <div style="width:260px; background:#2c3e50; color:white;">
      <jsp:include page="/WEB-INF/views/sidebar.jsp"/>
    </div>

    <!-- 우측 지도 -->
    <div style="flex:1;">
      <jsp:include page="/WEB-INF/views/initmap2.jsp"/>
    </div>
  </div>

</body>
</html>
