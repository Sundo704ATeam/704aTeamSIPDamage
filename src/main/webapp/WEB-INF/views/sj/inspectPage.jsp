<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>점검 등록</title>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
<style>
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

h2 {
	margin-bottom: 20px;
}

/* ✅ 카드 정렬 */
.form-row {
	display: flex;
	flex-wrap: nowrap;
	gap: 20px;
}

.form-row .card {
	flex: 1 1 400px; /* 최소 400px, 그 이상은 균등 분배 */
	box-sizing: border-box;
}

/* ✅ 카드 안쪽 폼 레이아웃 (Grid) */
.form-grid {
	display: grid;
	grid-template-columns: 150px 1fr; /* 왼쪽 라벨, 오른쪽 입력 */
	row-gap: 14px;
	column-gap: 12px;
	align-items: center;
}

.form-grid label {
	font-weight: bold;
	text-align: left;
}

.form-grid input, .form-grid select {
	width: 100%;
	padding: 6px;
	border: 1px solid #ccc;
	border-radius: 4px;
}

.card {
	padding: 20px;
}
</style>
</head>
<body>
	<form id="inspectForm" action="${pageContext.request.contextPath}/damageMap/inspect/save"
		method="post" class="mt-3">
		<div class="form-row">
			<div class="card">
				<h5 class="mb-3">점검등록</h5>
				<div class="form-grid">
					<!-- 관리코드 hidden -->
					<input type="hidden" name="managecode" value="${managecode}" />

					<label>점검일</label>
					<input type="date" name="ins_date" class="form-control" required>

					<label>점검자</label>
					<input type="text" name="inspactor" class="form-control" placeholder="점검자 이름" required>

					<label>균열 (객체수)</label>
					<input type="number" name="crackcnt" class="form-control" min="0" value="0">

					<label>누전 (객체수)</label>
					<input type="number" name="elecleakcnt" class="form-control" min="0" value="0">

					<label>누수 (객체수)</label>
					<input type="number" name="leakcnt" class="form-control" min="0" value="0">

					<label>변형 (객체수)</label>
					<input type="number" name="variationcnt" class="form-control" min="0" value="0">

					<label>구조이상 (객체수)</label>
					<input type="number" name="abnormalitycnt" class="form-control" min="0" value="0">

					<!-- 버튼은 span 2 -->
					<div class="mt-4 text-end" style="grid-column: span 2;">
						<button type="submit" class="btn btn-success">등록</button>
						<a href="${pageContext.request.contextPath}/inspectList?managecode=${managecode}" 
						   class="btn btn-secondary">취소</a>
					</div>
				</div>
			</div>
		</div>
	</form>
	<script>
	document.getElementById("inspectForm").addEventListener("submit", function(e) {
		  e.preventDefault();

		  const formData = new FormData(this);
		  const jsonData = Object.fromEntries(formData); // { managecode: "1", ins_date: "2025-09-17", ... }

		  fetch(this.action, {
		    method: "POST",
		    headers: { "Content-Type": "application/json" }, // JSON이라고 명시
		    body: JSON.stringify(jsonData)                  // JSON 문자열로 변환
		  })
		  .then(r => r.json())
		  .then(data => {
		    if (data.success) {
		      alert("등록완료 되었습니다");
		      if (window.opener && !window.opener.closed) {
		        window.opener.location.reload();
		      }
		      window.close();
		    } else {
		      alert("등록 실패!");
		    }
		  })
		  .catch(err => console.error(err));
		});
</script>
</body>
</html>