<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>점검 등록</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    body {
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }
    main {
      margin: 80px auto 0 auto;
      padding: 20px;
      max-width: 800px;
    }
  </style>
</head>
<body>

  <main>
    <h3>점검 등록</h3>

    <form action="${pageContext.request.contextPath}/inspect/save" method="post" class="mt-3">
      <!-- 관리코드 hidden -->
      <input type="hidden" name="managecode" value="${managecode}"/>

      <!-- 점검일 -->
      <div class="mb-3">
        <label class="form-label">점검일</label>
        <input type="date" name="ins_date" class="form-control" required>
      </div>

      <!-- 점검자 -->
      <div class="mb-3">
        <label class="form-label">점검자</label>
        <input type="text" name="inspactor" class="form-control" placeholder="점검자 이름" required>
      </div>

      <!-- 균열 -->
        <div class="col-md-6 mb-3">
          <label class="form-label">균열 (객체수)</label>
          <input type="number" name="crackcnt" class="form-control" min="0" value="0">
        </div>

      <!-- 누전 -->
        <div class="col-md-6 mb-3">
          <label class="form-label">누전 (객체수)</label>
          <input type="number" name="elecleakcnt" class="form-control" min="0" value="0">
        </div>
      <!-- 누수 -->
        <div class="col-md-6 mb-3">
          <label class="form-label">누수 (객체수)</label>
          <input type="number" name="leakcnt" class="form-control" min="0" value="0">
        </div>

      <!-- 변형 -->
        <div class="col-md-6 mb-3">
          <label class="form-label">변형 (객체수)</label>
          <input type="number" name="variationcnt" class="form-control" min="0" value="0">
        </div>

      <!-- 구조이상 -->
        <div class="col-md-6 mb-3">
          <label class="form-label">구조이상 (객체수)</label>
          <input type="number" name="abnormalitycnt" class="form-control" min="0" value="0">
        </div>

      <!-- 버튼 -->
      <div class="mt-4 text-end">
        <button type="submit" class="btn btn-success">등록</button>
        <a href="${pageContext.request.contextPath}/inspectList?managecode=${managecode}" 
           class="btn btn-secondary">취소</a>
      </div>
    </form>
  </main>

</body>
</html>
