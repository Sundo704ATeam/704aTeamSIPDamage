<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 목록</title>
  <style>
    body { 
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
      margin:0; 
      background:#f5f6fa; 
      color:#333;
      display: flex;
    }

    .content {
      flex: 1; 
      padding: 100px 20px 20px 20px; /* ✅ 위쪽 여백 늘림 */
      margin-left: 220px; /* 사이드바 폭 맞추기 */
    }

    h2 {
      margin-bottom: 20px;
      color: #2c3e50;
      font-weight: 600;
    }

    /* ✅ 검색창 */
    .search-box {
      margin-bottom: 20px;
    }
    .search-box input {
      width: 250px;
      padding: 8px 12px;
      border: 1px solid #ccc;
      border-radius: 4px;
      font-size: 14px;
    }
    .search-box button {
      padding: 8px 14px;
      margin-left: 6px;
      background: #3498db;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
    }
    .search-box button:hover {
      background: #2c80b4;
    }

    .table-container {
      width: 100%;
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.05);
      overflow-x: auto;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      min-width: 900px;
    }

    th, td {
      padding: 12px 14px;
      border-bottom: 1px solid #eee;
      text-align: center; /* ✅ 가운데 정렬 */
    }

    th {
      background: #f0f2f5;
      color: #333;
      font-weight: 600;
    }

    tbody tr:hover {
      background: #f9f9f9;
    }

	a.btn {
	  display: inline-block;
	  padding: 6px 12px;
	  border: 1px solid #d1d5db;
	  background: #ffffff;
	  color: #333;
	  border-radius: 6px;
	  font-size: 13px;
	  font-weight: 500;
	  text-decoration: none;
	  transition: background 0.2s, box-shadow 0.2s;
	}
	a.btn:hover {
	  background: #f9fafb;
	  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
	}
	a.btn:active {
	  background: #f3f4f6;
	}

  </style>
</head>
<body>

  <!-- 공용 include -->
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <div class="content">
    <h2>사회기반시설 목록</h2>

    <!-- ✅ 검색창 -->
    <div class="search-box">
      <form action="${pageContext.request.contextPath}/StructureList" method="get">
        <input type="text" name="keyword" placeholder="검색어를 입력하세요">
        <button type="submit">검색</button>
      </form>
    </div>

    <div class="table-container">
      <table>
        <thead>
          <tr>
            <td>관리코드</td>
            <td>이름</td>
            <td>종류</td>
            <td>세부종류</td>
            <td>종별</td>
            <td>주소</td>
            <td>최근 점검 일자</td>
            <td>점검 내역</td>
            <td>건물 상세</td>
            
          </tr>
        </thead>
        <tbody>
          <c:forEach var="s" items="${structures}">
            <tr>
              <td>${s.managecode}</td>
              <td>${s.name}</td>
              <td>${s.type}</td>
              <td>${s.typedetail}</td>
              <td>${s.sort}</td>
              <td>${s.address}</td>
			  <td>${s.latest_ins_date}</td>
              <td>
			  <a href="${pageContext.request.contextPath}/inspectList?managecode=${s.managecode}" class="btn">
			    내역 보기 
			  </a>
			</td>
			<td>
			  <a href="${pageContext.request.contextPath}/structureDetail?managecode=${s.managecode}" class="btn">
			    정보 보기
			  </a>
			</td>
			</tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>

</body>
</html>
