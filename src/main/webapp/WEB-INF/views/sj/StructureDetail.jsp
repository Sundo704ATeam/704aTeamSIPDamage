<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>건물 상세정보</title>
  <style>
    /* 레이아웃 */
    body {
      margin: 0;
      font-family: 'Noto Sans KR', 'Segoe UI', sans-serif;
      background-color: #f6f7f9;
      color: #333;
      display: flex;
    }
	.content {
	  flex: 1; 
	  padding: 200px 20px 20px 20px;
	  margin-left: 220px;
	}
    .container {
      width: 100%;
      max-width: 960px;
      margin: 0 auto;
    }

    h2 {
      margin: 0 0 20px 0;
      font-weight: 700;
      font-size: 1.8rem;
      color: #222;
    }

    .card {
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 10px;
      box-shadow: 0 3px 10px rgba(0,0,0,0.05);
      overflow: hidden;
    }
    .detail-table {
      width: 100%;
      border-collapse: collapse;
    }
    .detail-table th, .detail-table td {
      padding: 14px 18px;
      border-bottom: 1px solid #f0f0f0;
    }
    .detail-table th {
      width: 200px;
      background: #fafbfc;
      font-weight: 600;
      color: #555;
      text-align: center;
    }
    .detail-table tr:last-child th,
    .detail-table tr:last-child td {
      border-bottom: none;
    }

    .actions {
      margin-top: 16px;
      display: flex;
      justify-content: flex-start;
      gap: 8px;
    }

    .btn {
      display: inline-block;
      padding: 9px 16px;
      border: 1px solid #d1d5db;
      background: #ffffff;
      color: #111827;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      line-height: 1;
      transition: background 0.15s ease, box-shadow 0.15s ease, transform 0.05s ease;
    }
    .btn:hover {
      background: #f3f4f6;
      box-shadow: 0 2px 6px rgba(0,0,0,0.06);
    }
    .btn:active {
      transform: translateY(1px);
    }
  </style>
</head>
<body>

  <!-- 공용 include -->
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <div class="content">
    <div class="container">
      <h2>건물 상세정보</h2>

      <div class="card">
        <table class="detail-table">
          <tr><th>관리코드</th><td>${structure.managecode}</td></tr>
          <tr><th>건물명</th><td>${structure.name}</td></tr>
          <tr><th>종류</th><td>${structure.type}</td></tr>
          <tr><th>상세종류</th><td>${structure.typedetail}</td></tr>
          <tr><th>종별</th><td>${structure.sort}</td></tr>
          <tr><th>주소</th><td>${structure.address}</td></tr>
          <tr><th>X 좌표</th><td>${structure.x}</td></tr>
          <tr><th>Y 좌표</th><td>${structure.y}</td></tr>
        </table>
      </div>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/StructureList" class="btn">← 목록으로</a>
      </div>
    </div>
  </div>

</body>
</html>
