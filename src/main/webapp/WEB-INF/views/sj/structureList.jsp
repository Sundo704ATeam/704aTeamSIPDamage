<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사회기반시설 목록</title>
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
  padding: 100px 20px 20px 20px;
  margin-left: var(--rail-w); /* ✅ 사이드바랑 동일하게 */
}

h2 {
	margin-bottom: 20px;
	color: #2c3e50;
	font-weight: 600;
}

/* ✅ 검색창 */
.search-box {
  margin-bottom: 20px;
  display: flex;          /* 한 줄로 정렬 */
  align-items: center;    /* 높이 맞춤 */
  gap: 6px;               /* 요소 간격 일정 */
}

.search-box select,
.search-box input,
.search-box button {
  height: 38px;           /* ✅ 통일된 높이 */
  font-size: 14px;
}

.search-box select {
  padding: 0 8px;         /* 양쪽 패딩만 */
  border: 1px solid #ccc;
  border-radius: 4px;
  background: #fff;
}

.search-box input {
  width: 250px;
  padding: 0 10px;        /* 위아래 padding 없애고 정렬 */
  border: 1px solid #ccc;
  border-radius: 4px;
}

.search-box button {
  padding: 0 14px;        /* 좌우 패딩만 */
  background: #3498db;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.search-box button:hover {
  background: #2c80b4;
}

.table-container {
	width: 100%;
	background: #fff;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
	/* ⬇️ 여기 추가/수정 */
	max-height: 60vh; /* 원하는 높이로 조절 (px도 가능) */
	overflow-y: auto; /* 세로 스크롤 */
	overflow-x: hidden; /* 가로 스크롤 제거 (원하면 auto로 바꿔도 됨) */
	-webkit-overflow-scrolling: touch; /* 모바일 부드러운 스크롤 */
	padding: 0;
}

/* sticky 헤더 */
table {
	width: 100%;
	border-collapse: collapse;
	margin: 0;
	
}

th, td {
	padding: 12px 14px;
	border-bottom: 1px solid #eee;
	text-align: center; /* ✅ 가운데 정렬 */
	white-space: nowrap;
}

thead th {
	position: sticky;
	top: 0;
	z-index: 1;
	background: #f0f2f5; /* 헤더 배경 고정 */
	box-shadow: 0 1px 0 rgba(0, 0, 0, 0.06);
	
	text-align: center;
}

th {
	background: #f0f2f5;
	color: #333;
	font-weight: 600;
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

@media (max-width: 1700px) {
  td:nth-child(6), th:nth-child(6) {
    display: none; /* ✅ 주소 열 숨김 */
  }
}

@media (max-width: 1500px) {
  td:nth-child(4), th:nth-child(4),
  td:nth-child(5), th:nth-child(5) {
    display: none;
  }
}
/* ✅ 건물 등록 버튼 */
.register-btn {
  margin-left: auto;          /* 오른쪽 끝으로 밀기 */
  background: #27ae60;
  color: #fff !important;
  border: none;
  border-radius: 4px;
  padding: 8px 14px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  text-decoration: none;
}
.register-btn:hover {
  background: #1e874b;
}

</style>
</head>
<body>
	<!-- 공용 include -->
	<jsp:include page="/WEB-INF/views/header.jsp" />
	<jsp:include page="/WEB-INF/views/sidebar.jsp" />

	<div class="content">
		<h2>사회기반시설 목록</h2>

		<div class="search-box">
		  <form action="${pageContext.request.contextPath}/structureSearch" method="get">
		    <select name="filter">
		      <option value="all" <c:if test="${filter == 'all'}">selected</c:if>>전체</option>
		      <option value="managecode" <c:if test="${filter == 'managecode'}">selected</c:if>>관리코드</option>
		      <option value="name" <c:if test="${filter == 'name'}">selected</c:if>>이름</option>
		      <option value="type" <c:if test="${filter == 'type'}">selected</c:if>>종류</option>
		      <option value="sort" <c:if test="${filter == 'sort'}">selected</c:if>>종별</option>
		    </select>
		    <input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${keyword}">
		    <button type="submit">검색</button>
		  </form>
		<!-- ✅ 건물 등록 버튼 -->
		<a href="javascript:void(0);" 
		   onclick="window.open('${pageContext.request.contextPath}/sj/registerPage', 
		                        '_blank', 
		                        'width=800,height=550');" 
		   class="register-btn">
		   건물 등록
		</a>
		</div>
		
		<div class="table-container">
			<table>
				<thead>
					<tr>
						<th>관리코드</th>
						<th>이름
						</td>
						<th>종류</th>
						<th>세부종류</th>
						<th>종별</th>
						<th>주소</th>
						<th>최근 점검 일자</th>
						<th>점검 내역</th>
						<th>건물 상세</th>

					</tr>
				</thead>
				<tbody>
					<c:forEach var="s" items="${structures}">
						<tr>
							<td>${s.managecode}</td>
							<td>${s.name}</td>
							<td>${s.type}</td>
							<td>${s.typedetail}</td>
							<td>${s.sort}</td>
							<td>${s.address}</td>
							<td>${s.latest_ins_date}</td>
							<td><a href="javascript:void(0);" class="btn"
								onclick="window.open('${pageContext.request.contextPath}/inspectList?managecode=${s.managecode}', 
			                          'inspectWin', 
			                          'width=1000,height=700,scrollbars=yes,resizable=yes');">
									내역 보기 </a></td>
							<td><a
								href="${pageContext.request.contextPath}/structureDetail?managecode=${s.managecode}"
								class="btn"> 정보 보기 </a></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

</body>
</html>