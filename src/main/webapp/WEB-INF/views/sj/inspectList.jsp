<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<!-- exel아이콘 -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<title>점검 내역</title>
<style>
body {
	font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	margin: 0;
	background: #f5f6fa;
	color: #333;
	display: flex;
}

.content {
	flex: 1;
	padding: 20px; /* ✅ 위쪽 여백 최소화 */
	margin-left: var(--rail-w); /* 사이드바 폭 맞추기 */
}

h2 {
	margin-bottom: 20px;
	color: #2c3e50;
	font-weight: 600;
}

.table-container {
	width: 100%;
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	max-height: 60vh;
	overflow-y: auto;
	overflow-x: hidden;
	-webkit-overflow-scrolling: touch;
	padding: 0;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin: 0;
	table-layout: fixed;
}

th, td {
	padding: 12px 14px;
	border-bottom: 1px solid #eee;
	text-align: center;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

thead th {
	position: sticky;
	top: 0;
	z-index: 1;
	background: #f0f2f5;
	box-shadow: 0 1px 0 rgba(0, 0, 0, 0.06);
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
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

a.btn:active {
	background: #f3f4f6;
}

.btn-register {
	display: inline-block; /* ✅ 또는 block */
	margin-top: 30px; /* ✅ 리스트와 간격 띄우기 */
	padding: 10px 18px;
	background: #2ecc71;
	color: #fff;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-size: 14px;
}

.btn-register:hover {
	background: #27ae60;
}

.table-header {
	display: flex;
	justify-content: space-between; /* 좌우 배치 */
	align-items: center;
	margin-bottom: 10px;
}

.btn-excel {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	width: 34px;
	height: 34px;
	border-radius: 6px;
	background: #1d6f42;
	color: #fff;
	font-size: 16px;
	text-decoration: none;
	transition: background 0.2s;
}

.btn-excel:hover {
	background: #14532d;
}
</style>
</head>
<body>

	<div class="content">
		<div class="table-header">
			<h2>점검 내역</h2>
			<a
				href="${pageContext.request.contextPath}/damageMap/inspect/excelDownload?managecode=${managecode}"
				class="btn-excel" title="엑셀 다운로드"> <i
				class="fa-solid fa-file-excel"></i>
			</a>
		</div>

		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>점검일</th>
						<th>점검자</th>
						<th>균열(등급)</th>
						<th>누전(등급)</th>
						<th>누수(등급)</th>
						<th>변형(등급)</th>
						<th>구조이상(등급)</th>
						<th>상세이력</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="inspect" items="${inspects}">
						<tr>
							<td>${inspect.ins_date}</td>
							<td>${inspect.inspactor}</td>
							<td>${inspect.crackcnt}[${inspect.crack_grade}]</td>
							<td>${inspect.elecleakcnt}[${inspect.elecleak_grade}]</td>
							<td>${inspect.leakcnt}[${inspect.leak_grade}]</td>
							<td>${inspect.variationcnt}[${inspect.variation_grade}]</td>
							<td>${inspect.abnormalitycnt}[${inspect.abnormality_grade}]</td>
							<td><a
								href="${pageContext.request.contextPath}/damageMap/inspect/detail?inscode=${inspect.inscode}"
								class="btn">상세보기</a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<a
			href="${pageContext.request.contextPath}/damageMap/inspect/new?managecode=${managecode}"
			class="btn-register">점검 등록</a>
	</div>

</body>
</html>