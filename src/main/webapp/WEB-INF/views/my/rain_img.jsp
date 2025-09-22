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
    footer {
      position: fixed; left:0; right:0; bottom:0; height:var(--footer-h);
      background: var(--gray-800); color:#fff;
      display:flex; align-items:center; justify-content:center;
      border-top:1px solid var(--gray-700);
      z-index:1000;
    }
    
    #dropdownWrapper {
	    position: fixed; /* 상단 고정 */
	    top: calc(var(--header-h, 60px) + 80px);
	    left: 200px;
	    margin-left: 100px;
	    z-index: 100;
	}
	
	#dateSelect {
	    padding: 5px 10px;
	    font-size: 14px;
	    border-radius: 4px;
	    border: 1px solid #ccc;
	    background-color: #fff;
	}
	
	/* 중앙 이미지 영역 */
	#container {
	    display: flex;
	    justify-content: center; /* 수평 중앙 */
	    align-items: center;     /* 수직 중앙 */
	    height: calc(100vh - 150px); /* 헤더+footer 제외 */
	    margin-top: 100px; /* header와 간격 */
	}
	
	#gifContainer img {
	    max-width: 80%;
	    max-height: 80%;
	    border: 2px solid #ddd;
	    border-radius: 8px;
	    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
	}
    
  </style>

</head>
<body>
  <%@ include file="/WEB-INF/views/header.jsp" %>
  <%@ include file="/WEB-INF/views/sidebar.jsp" %>
  <%@ include file="/WEB-INF/views/sisidebar.jsp" %>

  <!-- 오른쪽 상단 드롭다운 -->
  <div id="dropdownWrapper">
    <select id="dateSelect">
      <c:forEach var="fileName" items="${dates}">
        <!-- 확장자 제거해 YYYYMMdd만 보여주고, 값은 전체 파일명 -->
        <option value="${fileName}">${fn:substringBefore(fileName, '.')}</option>
      </c:forEach>
    </select>
  </div>

  <!-- 가운데 이미지 -->
  <div id="container">
    <div id="gifContainer">
      <c:if test="${not empty dates}">
        <img id="gifImage" src="<c:url value='/rain/img/${dates[0]}'/>" alt="GIF 이미지"/>
      </c:if>
    </div>
  </div>

  <footer>© 사회기반시설 스마트 유지관리 시스템</footer>
  
  <script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function() {
      const select = document.getElementById('dateSelect');
      const gifImage = document.getElementById('gifImage');
      const baseUrl = '<c:url value="/rain/img/"/>';

      // 첫 페이지 진입 시 첫 번째(최신) 항목 선택
      if (select.options.length > 0) {
        select.selectedIndex = 0;
      }

      // 드롭다운 변경 시 이미지 교체
      select.addEventListener('change', function() {
        gifImage.src = baseUrl + encodeURIComponent(this.value);
      });
    });
  </script>
</body>
</html>