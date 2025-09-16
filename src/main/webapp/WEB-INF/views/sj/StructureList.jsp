<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>건물 목록</title>
  <style>
    body { font-family: Arial, sans-serif; margin:0; }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 8px;
      text-align: center;
    }
    th {
      background-color: #f4f4f4;
    }
    tr:hover {
      background-color: #f9f9f9;
    }
    a {
      text-decoration: none;
      color: #3498db;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <!-- 공용 include -->
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <h2 style="margin:20px;">건물 목록</h2>

  <table>
    <thead>
      <tr>
        <th>관리코드</th>
        <th>종류</th>
        <th>이름</th>
        <th>주소</th>
        <th>X</th>
        <th>Y</th>
        <th>재료</th>
        <th>상세보기</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="s" items="${structures}">
        <tr>
          <td>${s.managecode}</td>
          <td>${s.type}</td>
          <td>${s.name}</td>
          <td>${s.address}</td>
          <td>${s.x}</td>
          <td>${s.y}</td>
          <td>${s.materials}</td>
          <td>
            <a href="${pageContext.request.contextPath}/StructureDetail?managecode=${s.managecode}">
              상세보기
            </a>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

</body>
</html>
