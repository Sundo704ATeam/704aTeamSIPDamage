<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>점검 내역</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh; /* 화면 전체 높이 채우기 */
    }
    main {
      flex: 1; /* 푸터 제외 나머지 공간 채우기 */
      margin-top: 80px;   /* 헤더 높이만큼 띄우기 */
      margin-left: 220px; /* 사이드바 폭만큼 밀기 */
      padding: 20px;
    }
    footer {
      background: #333;
      color: #fff;
      text-align: center;
      padding: 10px 0;
      margin-left: 220px; /* 사이드바 아래에 맞추기 */
    }

    /* 작은 화면에서는 사이드바 겹치게 */
    @media (max-width: 768px) {
      main {
        margin-left: 0;
      }
      footer {
        margin-left: 0;
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <!-- ✅ 메인 컨텐츠 -->
  <main>
    <h3>점검 내역</h3>

    <div class="table-responsive mt-3">
      <table class="table table-bordered table-hover text-center align-middle">
        <thead class="table-light">
          <tr>
            <th>점검일</th>
            <th>점검자</th>
            <th>균열</th>
            <th>균열등급</th>
            <th>누전</th>
            <th>누전등급</th>
            <th>누수</th>
            <th>누수등급</th>
            <th>변형</th>
            <th>변형등급</th>
            <th>구조이상</th>
            <th>구조이상등급</th>
            <th>상세이력</th>
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
              <td>${inspect.abnormality}</td>
              <td>
                <a href="${pageContext.request.contextPath}/inspect/detail?inscode=${inspect.inscode}" 
                   class="btn btn-sm btn-primary">상세보기</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>

    <div class="mt-3">
      <a href="${pageContext.request.contextPath}/inspect/new?managecode=${managecode}" 
         class="btn btn-success">점검 등록</a>
    </div>
  </main>

</body>
</html>
