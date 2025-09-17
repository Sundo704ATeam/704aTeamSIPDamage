<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
    .impact-row td { display: flex; justify-content: space-between; align-items: center; }
    .btn { display: inline-block; padding: 6px 12px; border: 1px solid #d1d5db; background: #ffffff; color: #111827; border-radius: 6px; text-decoration: none; font-weight: 500; font-size: 13px; transition: background 0.15s ease, box-shadow 0.15s ease, transform 0.05s ease; }
    .btn:hover { background: #f3f4f6; box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
    .btn:active { transform: translateY(1px); }
    .btn-edit { background: #3498db; border-color: #2980b9; color: #fff; }
    .btn-edit:hover { background: #2980b9; }
    .actions { display: flex; gap: 10px; margin-top: 20px; }
  </style>
</head>
<body>

  <jsp:include page="/WEB-INF/views/header.jsp" />
  <jsp:include page="/WEB-INF/views/sidebar.jsp" />

  <div class="content">
    <div class="container">
      <h2>건물 상세정보</h2>

      <div class="detail-container">
        <!-- 왼쪽: 건물 속성 -->
        <div class="card">
          <h3>안전점검 결과</h3>
          <table class="detail-table">
            <tr><th>점검코드</th><th>관리번호</th><th>균열(등급)</th><th>누전(등급)</th><th>누수(등급)</th><th>변형(등급)</th><th>구조이상(등급)</th><th>점검자</th><th>점검일</th></tr>
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

        <!-- 오른쪽: 손상위치 + 사진파일 -->
        <div class="card">
          <h3>건물 영향도</h3>
          <table class="detail-table">
		<tr class="impact-row"><th>균열</th>
		  <td>
		    <c:choose>
		      <c:when test="${structure.crack == 10}">A</c:when>
		      <c:when test="${structure.crack == 8}">B</c:when>
		      <c:when test="${structure.crack == 6}">C</c:when>
		      <c:when test="${structure.crack == 4}">D</c:when>
		      <c:when test="${structure.crack == 2}">E</c:when>
		    </c:choose>
		  </td>
		</tr>

		<tr class="impact-row"><th>누전</th>
		  <td>
		    <c:choose>
		      <c:when test="${structure.elecleak == 10}">A</c:when>
		      <c:when test="${structure.elecleak == 8}">B</c:when>
		      <c:when test="${structure.elecleak == 6}">C</c:when>
		      <c:when test="${structure.elecleak == 4}">D</c:when>
		      <c:when test="${structure.elecleak == 2}">E</c:when>
		    </c:choose>
		  </td>
		</tr>
		
		<tr class="impact-row"><th>누수</th>
		  <td>
		    <c:choose>
		      <c:when test="${structure.leak == 10}">A</c:when>
		      <c:when test="${structure.leak == 8}">B</c:when>
		      <c:when test="${structure.leak == 6}">C</c:when>
		      <c:when test="${structure.leak == 4}">D</c:when>
		      <c:when test="${structure.leak == 2}">E</c:when>
		    </c:choose>
		  </td>
		</tr>
		
		<tr class="impact-row"><th>변형</th>
		  <td>
		    <c:choose>
		      <c:when test="${structure.variation == 10}">A</c:when>
		      <c:when test="${structure.variation == 8}">B</c:when>
		      <c:when test="${structure.variation == 6}">C</c:when>
		      <c:when test="${structure.variation == 4}">D</c:when>
		      <c:when test="${structure.variation == 2}">E</c:when>
		    </c:choose>
		  </td>
		</tr>
		
		<tr class="impact-row"><th>구조이상</th>
		  <td>
		    <c:choose>
		      <c:when test="${structure.abnormality == 10}">A</c:when>
		      <c:when test="${structure.abnormality == 8}">B</c:when>
		      <c:when test="${structure.abnormality == 6}">C</c:when>
		      <c:when test="${structure.abnormality == 4}">D</c:when>
		      <c:when test="${structure.abnormality == 2}">E</c:when>
		    </c:choose>
		  </td>
		</tr>
          </table>
        </div>
      </div>

      <div class="actions">
        <a href="${pageContext.request.contextPath}/inspectList?managecode=${damage_InspectDto.managecode}" class="btn">← 목록으로</a>
      </div>
    </div>
  </div>

</body>
</html>
