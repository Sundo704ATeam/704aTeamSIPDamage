<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>점검결과 상세정보</title>
<style>
body {
	margin: 0;
	font-family: 'Noto Sans KR', 'Segoe UI', sans-serif;
	background-color: #f6f7f9;
	color: #333;
	display: flex;
	justify-content: center;
	align-items: flex-start;
	min-height: 100vh;
}

.content {
	flex: none;
	width: 100%;
	max-width: 1000px;
	padding: 40px 20px;
}

.container {
	width: 100%;
}

h2 {
	margin: 0 0 20px 0;
	font-weight: 700;
	font-size: 1.9rem;
	color: #2c3e50;
}

.detail-container {
	display: flex;
	flex-direction: column;
	gap: 20px;
	margin-bottom: 20px;
}

.card {
	background: #fff;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
	overflow: hidden;
}

.card h3 {
	margin: 0;
	padding: 14px 20px;
	background: #f9fafb;
	border-bottom: 1px solid #eee;
	font-size: 1.1rem;
	font-weight: 600;
	color: #444;
}

.detail-table {
	width: 100%;
	border-collapse: collapse;
}

.detail-table th {
	padding: 12px 16px;
	border-bottom: 1px solid #f0f0f0;
	white-space: nowrap;
	font-size: 14px;
}

.detail-table td {
	padding: 12px 16px;
	border-bottom: 1px solid #f0f0f0;
	text-align: center;
	white-space: nowrap;
	font-size: 14px;
}

.detail-table th {
	width: 160px;
	background: #fafbfc;
	font-weight: 600;
	color: #555;
	text-align: center;
}

.detail-table tr:last-child th, .detail-table tr:last-child td {
	border-bottom: none;
}

.actions {
	display: flex;
	gap: 10px;
	margin-top: 20px;
}

.inspection-list {
	display: flex;
	flex-wrap: wrap;
	gap: 16px;
	padding: 16px;
}

.inspection-item {
	flex: 1 1 280px;
	background: #fafafa;
	border: 1px solid #eee;
	border-radius: 10px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	overflow: hidden;
	display: flex;
	flex-direction: column;
}

.inspection-info {
	padding: 12px 14px;
	font-size: 14px;
	color: #444;
	border-bottom: 1px solid #e5e5e5;
}

.inspection-thumbnails {
	display: flex;
	flex-wrap: wrap;
	gap: 8px;
	padding: 10px;
}

.inspection-thumbnails img {
	width: 120px;
	height: 120px;
	object-fit: cover;
	border: 1px solid #ccc;
	border-radius: 6px;
	cursor: pointer;
	transition: transform 0.2s;
}

.inspection-thumbnails img:hover {
	transform: scale(1.05);
}

/* ✅ 모달 스타일 */
.modal {
	display: none;
	position: fixed;
	z-index: 2000;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.9);
	justify-content: center;
	align-items: center;
}

.modal-content {
	max-width: 90%;
	max-height: 90%;
	object-fit: contain;
	cursor: grabbing;
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%) scale(1);
}

.close {
	position: absolute;
	top: 20px;
	right: 35px;
	color: #fff;
	font-size: 40px;
	font-weight: bold;
	cursor: pointer;
	z-index: 2100;
}

.close:hover {
	color: #ccc;
}

.close:hover {
	color: #ccc;
}

.btn {
	display: inline-block;
	padding: 6px 12px;
	border: 1px solid #d1d5db;
	background: #ffffff;
	color: #111827;
	border-radius: 6px;
	text-decoration: none;
	font-weight: 500;
	font-size: 13px;
	transition: background 0.15s ease, box-shadow 0.15s ease, transform
		0.05s ease;
}

.btn:hover {
	background: #f3f4f6;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.06);
}

.btn:active {
	transform: translateY(1px);
}

.btn-edit {
	background: #3498db;
	border-color: #2980b9;
	color: #fff;
}

.btn-edit:hover {
	background: #2980b9;
}
</style>
</head>
<body>

	<div class="content">
		<div class="container">
			<h2>점검 상세정보</h2>

			<div class="detail-container">
				<!-- 상단: 점검등급표 -->
				<div class="card">
					<h3>안전점검 결과</h3>
					<table class="detail-table">
						<tr>
							<th>점검코드</th>
							<th>관리번호</th>
							<th>균열(등급)</th>
							<th>누전(등급)</th>
							<th>누수(등급)</th>
							<th>변형(등급)</th>
							<th>구조이상(등급)</th>
							<th>점검자</th>
							<th>점검일</th>
						</tr>
						<tr>
							<td>${damage_InspectDto.inscode}</td>
							<td>${damage_InspectDto.managecode}</td>
							<td>${damage_InspectDto.crackcnt}(${damage_InspectDto.crack_grade})</td>
							<td>${damage_InspectDto.elecleakcnt}(${damage_InspectDto.elecleak_grade})</td>
							<td>${damage_InspectDto.leakcnt}(${damage_InspectDto.leak_grade})</td>
							<td>${damage_InspectDto.variationcnt}(${damage_InspectDto.variation_grade})</td>
							<td>${damage_InspectDto.abnormalitycnt}(${damage_InspectDto.abnormality_grade})</td>
							<td>${damage_InspectDto.inspactor}</td>
							<td>${damage_InspectDto.ins_date}</td>
						</tr>
					</table>
				</div>

				<!-- 하단: 손상위치 + 사진파일 -->
				<div class="card">
					<h3>상세 점검내역</h3>
					<div class="inspection-list">
						<c:forEach var="entry" items="${imgMap}">
							<div class="inspection-item">
								<div class="inspection-info">
									<p>
										<strong>위치:</strong> ${entry.key}
									</p>
								</div>
								<div class="inspection-thumbnails">
									<c:forEach var="file" items="${entry.value}">
										<img
											src="${pageContext.request.contextPath}/damageMap/files/${file}"
											alt="점검사진" onclick="openModal(this.src)" />
									</c:forEach>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>

			<div class="actions">
				<a
					href="${pageContext.request.contextPath}/inspectList?managecode=${damage_InspectDto.managecode}"
					class="btn">← 목록으로</a>
			</div>
		</div>
	</div>

	<!-- ✅ 모달 -->
	<div class="modal" id="imageModal">
		<span class="close" onclick="closeModal(event)">&times;</span> <img
			class="modal-content" id="modalImage">
	</div>

	<script>
	// ✅ 제일 위에서 먼저 DOM 요소를 잡기
	const modal = document.getElementById("imageModal");
	const modalImg = document.getElementById("modalImage");

	let zoom = 1;
	let currentX = 0, currentY = 0;
	let isDragging = false, startX, startY;
	let pending = false; // 애니메이션 프레임 중복 방지

	function openModal(src) {
	  modal.style.display = "block";
	  modalImg.src = src;
	  resetImage();
	}

	function closeModal() {
	  modal.style.display = "none";
	}

	// ESC 닫기
	document.addEventListener("keydown", function(e) {
	  if (e.key === "Escape") {
	    closeModal();
	  }
	});

	// 배경 클릭 시 닫기
	modal.addEventListener("click", function(e) {
	  if (e.target === modal) {
	    closeModal();
	  }
	});

	function resetImage() {
	  zoom = 1;
	  currentX = 0;
	  currentY = 0;
	  modalImg.style.transform = "translate(-50%, -50%) scale(1)";
	}

	// ✅ 휠 확대/축소
	modalImg.addEventListener("wheel", function(e) {
	  e.preventDefault();
	  if (e.deltaY < 0) zoom += 0.1;
	  else zoom = Math.max(1, zoom - 0.1);

	  modalImg.style.transform =
	    "translate(calc(-50% + " + currentX + "px), calc(-50% + " + currentY + "px)) scale(" + zoom + ")";
	});

	// ✅ 드래그 이동
	modalImg.addEventListener("mousedown", function(e) {
	  if (e.button !== 0) return; // 좌클릭만
	  isDragging = true;
	  startX = e.clientX - currentX;
	  startY = e.clientY - currentY;
	  modalImg.style.cursor = "grabbing";

	  window.addEventListener("mousemove", onMouseMove);
	  window.addEventListener("mouseup", onMouseUp);
	});

	function onMouseMove(e) {
	  if (!isDragging) return;

	  // 마우스 좌표 계산
	  currentX = e.clientX - startX;
	  currentY = e.clientY - startY;

	  // requestAnimationFrame으로 최적화
	  if (!pending) {
	    pending = true;
	    requestAnimationFrame(() => {
	      modalImg.style.transform =
	        "translate(calc(-50% + " + currentX + "px), calc(-50% + " + currentY + "px)) scale(" + zoom + ")";
	      pending = false;
	    });
	  }
	}

	function onMouseUp() {
	  isDragging = false;
	  modalImg.style.cursor = "grab";
	  window.removeEventListener("mousemove", onMouseMove);
	  window.removeEventListener("mouseup", onMouseUp);
	}
	
	// 이미지 드래그 방지 (브라우저 기본 drag 막기)
	modalImg.addEventListener("dragstart", function(e) {
	  e.preventDefault();
	});
	</script>

</body>
</html>