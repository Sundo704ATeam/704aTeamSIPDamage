<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>황사/미세먼지 예보</title>
  <style>
    :root {
      --header-h: 60px;
      --footer-h: 40px;
      --rail-w: 60px;
      --tool-w: 120px;
    }

    html, body {
      margin: 0;
      height: 100%;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f5f6fa;
      color: #333;
    }

    .layout {
      display: flex;
      height: calc(100vh - var(--header-h) - var(--footer-h));
      margin-top: var(--header-h);
      margin-left: calc(var(--rail-w) + var(--tool-w));
      padding: 20px;
      gap: 20px;
      box-sizing: border-box;
    }

    .sidebar {
      width: 200px;
      border: 1px solid #ddd;
      padding: 10px;
      background: #f9f9f9;
      border-radius: 6px;
      overflow-y: auto;
    }

    .grade-box {
      display: inline-block;
      padding: 6px 10px;
      margin: 4px 0;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      background: #eef2ff;
      color: #1e40af;
      border: 1px solid #c7d2fe;
    }

    .main {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 15px;
      overflow-y: auto;
    }

    .search-bar {
      border: 1px solid #ddd;
      padding: 10px;
      background: #fff;
      border-radius: 6px;
      display: flex;
      flex-direction: row;
      gap: 10px;
      align-items: center;
      flex-wrap: nowrap;
    }
    .search-bar input[type="date"] { width: 160px; }
    .search-bar select { width: 100px; }
    .search-bar button { width: 70px; }

    .image-box {
      flex: 1;
      border: 1px solid #ddd;
      padding: 10px;
      text-align: center;
      background: #fff;
      border-radius: 6px;
    }
    .image-box img {
      max-width: 100%;
      border-radius: 6px;
      border: 1px solid #ccc;
    }

    .info-box {
      border: 1px solid #ddd;
      padding: 10px;
      background: #fff;
      border-radius: 6px;
    }

    .alert {
      padding: 10px;
      margin: 10px 0;
      border-radius: 6px;
      background: #fff3cd;
      border: 1px solid #ffeeba;
      color: #856404;
      font-size: 14px;
    }

    footer {
      position: fixed;
      bottom: 0;
      left: 0;
      right: 0;
      height: var(--footer-h);
      background: #1f2937;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 13px;
      z-index: 2100;
    }
  </style>
</head>
<body>
  <%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/sidebar.jsp" %>
  <%@ include file="/WEB-INF/views/sisidebar.jsp" %>

  <div class="layout">
    <!-- 좌측: 등급 -->
    <div class="sidebar">
      <h5>등급</h5>
      <c:choose>
        <c:when test="${not empty dustForecast.informGrade}">
          <c:forTokens var="grade" items="${dustForecast.informGrade}" delims=",">
            <div class="grade-box">${grade}</div>
          </c:forTokens>
        </c:when>
        <c:otherwise>
          <p class="alert">등급 데이터 없음</p>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 우측 메인 -->
    <div class="main">
      <!-- 조건 선택 -->
      <form class="search-bar" method="get" action="${pageContext.request.contextPath}/dustForecast">
        <input type="date" class="form-control" name="dateTime"
               value="${param.dateTime}">
        <select name="informCode" class="form-select">
          <option value="PM10" ${param.informCode == 'PM10' ? 'selected' : ''}>PM10</option>
          <option value="PM25" ${param.informCode == 'PM25' ? 'selected' : ''}>PM2.5</option>
        </select>
        <button type="submit" class="btn btn-primary">조회</button>
      </form>

      <!-- 이미지 -->
      <div class="image-box">
        <c:if test="${not empty dustForecast.path}">
          <img src="${pageContext.request.contextPath}${dustForecast.path}" alt="예보 이미지"/>
        </c:if>
        <c:if test="${empty dustForecast.path}">
          <p>이미지가 없습니다.</p>
        </c:if>
      </div>

      <!-- 상세 정보 -->
      <div class="info-box">
        <c:choose>
          <c:when test="${not empty dustForecast.dataTime}">
            <p><strong>발표시각:</strong> ${dustForecast.dataTime}</p>
            <p><strong>종합:</strong> ${dustForecast.informOverall}</p>
            <p><strong>원인:</strong> ${dustForecast.informCause}</p>
            <p><strong>행동요령:</strong> ${dustForecast.actionKnack}</p>
          </c:when>
          <c:otherwise>
            <div class="alert">해당 날짜 데이터가 없습니다.</div>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>

  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>
</body>
</html>
