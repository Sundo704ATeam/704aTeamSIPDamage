<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>점검 내역</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="container mt-4">

	<jsp:include page="/WEB-INF/views/header.jsp" />
	<jsp:include page="/WEB-INF/views/sidebar.jsp" />


  <div style="margin-top:100px;">   

  <h3>점검 내역</h3>
  <table class="table table-bordered table-hover text-center align-middle mt-3">
    <thead class="table-light">
      <tr>
      	<td>점검일</td>
        <td>점검자</td>
        <td>균열</td>
        <td>균열등급</td>
        <td>누전</td>
        <td>누전등급</td>
        <td>누수</td>
        <td>누전등급</td>
        <td>변형</td>
        <td>변형등급</td>
        <td>구조이상</td>
        <td>구조이상등급</td>
        <td>상세이력</td>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="inspect" items="${inspects}">
        <tr>
          <td>${inspect.ins_date}</td>
          <td>${inspect.inspactor}</td>
          <td>${inspect.crackcnt}</td>
          <td>${inspect.crack}</td>
          <td>${inspect.elecleakcnt}</td>
          <td>${inspect.elecleak}</td>
          <td>${inspect.leakcnt}</td>
          <td>${inspect.leak}</td>
          <td>${inspect.variationcnt}</td>
          <td>${inspect.variation}</td>
          <td>${inspect.abnomalitycnt}</td>
          <td>${inspect.variation}</td>
          <td>
            <a href="${pageContext.request.contextPath}/inspect/detail?inscode=${inspect.inscode}" 
               class="btn btn-sm btn-primary">상세보기</a>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div class="mt-3">
    <a href="${pageContext.request.contextPath}/inspect/new?managecode=${managecode}" 
       class="btn btn-success">점검 등록</a>
  </div>

</div>
</body>
</html>
