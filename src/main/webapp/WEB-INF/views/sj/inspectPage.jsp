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

.photo-row .btn-danger {
	height: 38px; /* input이랑 맞춤 (form-control 기본 높이랑 동일) */
	line-height: 1.2; /* 글자 세로 위치 맞추기 */
	white-space: nowrap; /* 글자 줄바꿈 방지 */
}
</style>
</head>
<body>
	<form id="inspectForm"
		action="${pageContext.request.contextPath}/damageMap/inspect/save"
		method="post" enctype="multipart/form-data" class="mt-3">

		<div class="form-row">
			<div class="card">
				<h5 class="mb-3">점검등록</h5>
				<div class="form-grid">
					<!-- 관리코드 hidden -->
					<input type="hidden" name="managecode" value="${managecode}" /> <label>점검일</label>
					<input type="date" name="ins_date" class="form-control" required>

					<label>점검자</label> <input type="text" name="inspactor"
						class="form-control" placeholder="점검자 이름" required> <label>균열(객체수)</label>
					<input type="number" name="crackcnt" class="form-control" min="0"
						value="0"> <label>누전 (객체수)</label> <input type="number"
						name="elecleakcnt" class="form-control" min="0" value="0">

					<label>누수 (객체수)</label> <input type="number" name="leakcnt"
						class="form-control" min="0" value="0"> <label>변형(객체수)</label>
					<input type="number" name="variationcnt" class="form-control"
						min="0" value="0"> <label>구조이상(객체수)</label> <input
						type="number" name="abnormalitycnt" class="form-control" min="0"
						value="0">
				</div>
			</div>
		</div>

		<!-- ✅ 위치별 사진 등록 카드 -->
		<div class="form-row mt-4">
			<div class="card">
				<h5 class="mb-3">위치별 사진 등록</h5>
				<div id="photoContainer" class="d-flex flex-column gap-3">
					<div class="photo-row d-flex flex-column gap-2">
						<div class="d-flex align-items-center gap-2">
							<input type="text" name="img_loc[0]" class="form-control imgLoc"
								placeholder="위치 입력" style="max-width: 200px;"> <input
								type="file" name="files[0]" class="form-control fileInput"
								accept="image/*" multiple onchange="previewFiles(this, 0)">
							<button type="button" class="btn btn-sm btn-danger"
								onclick="removeRow(this)">삭제</button>
						</div>
						<!-- ✅ 미리보기는 파일 선택 밑으로 -->
						<div class="preview d-flex gap-2 flex-wrap mt-2"></div>
					</div>
				</div>
				<div class="mt-3">
					<button type="button" class="btn btn-sm btn-outline-primary"
						onclick="addPhotoRow()">+ 항목 추가</button>
				</div>
			</div>
		</div>

		<!-- ✅ 등록/취소 버튼 -->
		<div class="mt-4 text-end">
			<button type="submit" class="btn btn-success">등록</button>
			<a
				href="${pageContext.request.contextPath}/inspectList?managecode=${managecode}"
				class="btn btn-secondary">취소</a>
		</div>
	</form>

	<script>
	function previewFiles(input, index) {
		  const previewContainer = input.closest(".photo-row").querySelector(".preview");
		  previewContainer.innerHTML = ""; // 이전 미리보기 초기화

		  if (input.files) {
		    Array.from(input.files).forEach(file => {
		      if (file.type.startsWith("image/")) {
		        const reader = new FileReader();
		        reader.onload = function(e) {
		          const img = document.createElement("img");
		          img.src = e.target.result;
		          img.style.width = "80px";
		          img.style.height = "80px";
		          img.style.objectFit = "cover";
		          img.style.border = "1px solid #ccc";
		          img.style.borderRadius = "6px";
		          previewContainer.appendChild(img);
		        };
		        reader.readAsDataURL(file);
		      }
		    });
		  }
		}

		function addPhotoRow() {
		  const container = document.getElementById("photoContainer");
		  const div = document.createElement("div");
		  div.className = "photo-row d-flex flex-column gap-2 mt-2";
		  div.innerHTML =
		    '<div class="d-flex align-items-center gap-2">' +
		      '<input type="text" name="" class="form-control imgLoc" placeholder="위치 입력" style="max-width:200px;">' +
		      '<input type="file" name="" class="form-control fileInput" accept="image/*" multiple onchange="previewFiles(this)">' +
		      '<button type="button" class="btn btn-sm btn-danger" onclick="removeRow(this)">삭제</button>' +
		    '</div>' +
		    '<div class="preview d-flex gap-2 flex-wrap mt-2"></div>';
		  container.appendChild(div);
		  reindexRows();
		}

		function removeRow(btn) {
		  btn.parentElement.remove();
		  reindexRows(); // 삭제 후 인덱스 다시 매기기
		}

		function reindexRows() {
		  const rows = document.querySelectorAll("#photoContainer .photo-row");
		  rows.forEach(function(row, index) {
		    const imgLocInput = row.querySelector(".imgLoc");
		    const fileInput = row.querySelector(".fileInput");
		    imgLocInput.setAttribute("name", "img_loc[" + index + "]");
		    fileInput.setAttribute("name", "files[" + index + "]");
		  });
		}
		
		document.getElementById("inspectForm").addEventListener("submit", function(e) {
			  e.preventDefault();

			  const formData = new FormData(this);

			  fetch(this.action, {
			    method: "POST",
			    body: formData
			  })
			  .then(r => r.json())
			  .then(data => {
			    if (data.success) {
			      alert("등록이 완료되었습니다");
			      if (window.opener && !window.opener.closed) {
			        window.opener.location.reload(); // 부모창 새로고침
			      }
			      window.close(); // 현재 등록 팝업창 닫기
			    } else {
			      alert("등록 실패 ❌ 다시 시도해주세요.");
			    }
			  })
			  .catch(err => {
			    console.error("에러 발생:", err);
			    alert("서버 오류가 발생했습니다.");
			  });
			});
			</script>
	</script>
</body>
</html>