<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>건물 수정페이지</title>
  <style>
    body {
      margin: 0;
      font-family: 'Noto Sans KR', 'Segoe UI', sans-serif;
      background-color: #f6f7f9;
      color: #333;
      display: flex;
    }
    .content { flex: 1; padding: 200px 20px 20px 20px; margin-left: 220px; }
    .container { width: 100%; max-width: 1200px; margin: 0 auto; }
    h2 { margin: 0 0 20px 0; font-weight: 700; font-size: 1.9rem; color: #2c3e50; }
    .detail-container { display: flex; gap: 20px; margin-bottom: 20px; }
    .card { background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 3px 10px rgba(0,0,0,0.05); flex: 1; overflow: hidden; }
    .card h3 { margin: 0; padding: 14px 20px; background: #f9fafb; border-bottom: 1px solid #eee; font-size: 1.1rem; font-weight: 600; color: #444; }
    .detail-table { width: 100%; border-collapse: collapse; }
    .detail-table th, .detail-table td { padding: 12px 16px; border-bottom: 1px solid #f0f0f0; font-size: 14px; }
    .detail-table th { width: 160px; background: #fafbfc; font-weight: 600; color: #555; text-align: center; }
    .detail-table tr:last-child th, .detail-table tr:last-child td { border-bottom: none; }
    .actions { display: flex; gap: 10px; margin-top: 20px; }
    .btn { display: inline-block; padding: 6px 12px; border: 1px solid #d1d5db; background: #ffffff; color: #111827; border-radius: 6px; text-decoration: none; font-weight: 500; font-size: 13px; transition: background 0.15s ease, box-shadow 0.15s ease, transform 0.05s ease; }
    .btn:hover { background: #f3f4f6; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
    .btn:active { transform: translateY(1px); }
    .btn-edit { background: #3498db; border-color: #2980b9; color: #fff; }
    .btn-edit:hover { background: #2980b9; }
  </style>
</head>
<body>

  <!-- 공용 include -->
  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <div class="content">
    <div class="container">
      <h2>건물 수정</h2>

      <!-- ✅ 수정 폼 시작 -->
		<form action="${pageContext.request.contextPath}/structure/update" method="post">
              <input type="hidden" name="managecode" value="${structure.managecode}"/>

        <div class="detail-container">
          <!-- 왼쪽: 건물 속성 -->
          <div class="card">
            <h3>건물 속성</h3>
            <table class="detail-table">
              <tr><th>건물명</th><td><input type="text" name="name" value="${structure.name}" class="form-control"/></td></tr>
              <tr><th>종류</th><td><input type="text" name="type" value="${structure.type}" class="form-control"/></td></tr>
              <tr><th>상세종류</th><td><input type="text" name="typedetail" value="${structure.typedetail}" class="form-control"/></td></tr>
              <tr><th>종별</th><td><input type="text" name="sort" value="${structure.sort}" class="form-control"/></td></tr>
              <tr><th>주소</th><td><input type="text" name="address" value="${structure.address}" class="form-control"/></td></tr>
              <tr><th>구조</th><td><input type="text" name="materials" value="${structure.materials}" class="form-control"/></td></tr>
              <tr><th>X 좌표</th><td><input type="number" step="0.01" name="x" value="${structure.x}" class="form-control"/></td></tr>
              <tr><th>Y 좌표</th><td><input type="number" step="0.01" name="y" value="${structure.y}" class="form-control"/></td></tr>
            </table>
          </div>

          <!-- 오른쪽: 영향도 -->
          <div class="card">
            <h3>건물 영향도</h3>
            <table class="detail-table">
              <tr><th>균열</th>
                <td>
                 <select name="crack" class="form-select">
				  <option value="10" <c:if test="${structure.crack eq '10'}">selected</c:if>>A</option>
				  <option value="8" <c:if test="${structure.crack eq '8'}">selected</c:if>>B</option>
				  <option value="6" <c:if test="${structure.crack eq '6'}">selected</c:if>>C</option>
				  <option value="4" <c:if test="${structure.crack eq '4'}">selected</c:if>>D</option>
				  <option value="2" <c:if test="${structure.crack eq '2'}">selected</c:if>>E</option>
				</select>
                </td>
              </tr>
              <tr><th>누전</th>
                <td>
                 <select name="elecleak" class="form-select">
				  <option value="10" <c:if test="${structure.elecleak eq '10'}">selected</c:if>>A</option>
				  <option value="8" <c:if test="${structure.elecleak eq '8'}">selected</c:if>>B</option>
				  <option value="6" <c:if test="${structure.elecleak eq '6'}">selected</c:if>>C</option>
				  <option value="4" <c:if test="${structure.elecleak eq '4'}">selected</c:if>>D</option>
				  <option value="2" <c:if test="${structure.elecleak eq '2'}">selected</c:if>>E</option>
				</select>
                  </select>
                </td>
              </tr>
              <tr><th>누수</th>
                <td>
				<select name="leak" class="form-select">
				  <option value="10" <c:if test="${structure.leak eq '10'}">selected</c:if>>A</option>
				  <option value="8" <c:if test="${structure.leak eq '8'}">selected</c:if>>B</option>
				  <option value="6" <c:if test="${structure.leak eq '6'}">selected</c:if>>C</option>
				  <option value="4" <c:if test="${structure.leak eq '4'}">selected</c:if>>D</option>
				  <option value="2" <c:if test="${structure.leak eq '2'}">selected</c:if>>E</option>
				</select>
                </td>
              </tr>
              <tr><th>변형</th>
                <td>
				<select name="variation" class="form-select">
				  <option value="10" <c:if test="${structure.variation eq '10'}">selected</c:if>>A</option>
				  <option value="8" <c:if test="${structure.variation eq '8'}">selected</c:if>>B</option>
				  <option value="6" <c:if test="${structure.variation eq '6'}">selected</c:if>>C</option>
				  <option value="4" <c:if test="${structure.variation eq '4'}">selected</c:if>>D</option>
				  <option value="2" <c:if test="${structure.variation eq '2'}">selected</c:if>>E</option>
				</select>
                </td>
              </tr>
              <tr><th>구조이상</th>
                <td>
				<select name="abnormality" class="form-select">
				  <option value="10" <c:if test="${structure.abnormality eq '10'}">selected</c:if>>A</option>
				  <option value="8" <c:if test="${structure.abnormality eq '8'}">selected</c:if>>B</option>
				  <option value="6" <c:if test="${structure.abnormality eq '6'}">selected</c:if>>C</option>
				  <option value="4" <c:if test="${structure.abnormality eq '4'}">selected</c:if>>D</option>
				  <option value="2" <c:if test="${structure.abnormality eq '2'}">selected</c:if>>E</option>
				</select>
                </td>
              </tr>
            </table>
          </div>
        </div>

        <div class="actions">
          <button type="submit" class="btn btn-edit">저장</button>
			<a href="javascript:history.back()" class="btn">취소</a>
        </div>
      </form>
      <!-- ✅ 수정 폼 끝 -->

    </div>
  </div>

</body>
</html>
