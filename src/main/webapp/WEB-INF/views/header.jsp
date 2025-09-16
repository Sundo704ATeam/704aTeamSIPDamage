<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- OpenLayers / Bootstrap -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@7.4.0/ol.css" />
<script src="https://cdn.jsdelivr.net/npm/ol@7.4.0/dist/ol.js"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- JQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 프로젝트 공통 CSS (있다면 유지) -->
<%-- <link rel="stylesheet" href="<c:url value='/resources/css/style.css' />"> --%>

<style>
  :root{
    /* 레이아웃 치수 */
    --header-h: 56px;
    --rail-w:   100px;

    /* 회색 테마 팔레트 */
    --gray-900:#111827;
    --gray-800:#1f2937;
    --gray-700:#374151;
    --gray-600:#4b5563;
    --gray-500:#6b7280;
    --gray-300:#d1d5db;
    --gray-200:#e5e7eb;
    --gray-100:#f3f4f6;

    /* 포커스/강조 색(선택) */
    --accent:#3b82f6;
  }

  /* 버튼 표준 (회색 아웃라인) */
  .btn-gray-outline{
    border:1px solid var(--gray-700);
    color: var(--gray-700);
    background: transparent;
  }
  .btn-gray-outline:hover{
    background:#ccc;
    color:#333;
    border-color:#ccc;
  }

  /* 고정 헤더 */
  header.app-header{
    position:fixed; z-index:1000;
    top:0; left:0; right:0; height:var(--header-h);
    background: var(--gray-800);
    border-bottom:1px solid var(--gray-700);
    display:flex; align-items:center; padding:0 16px;
  }
  header.app-header .title{
    color:#fff; font-size:18px; font-weight:600; margin:0;
  }
</style>

<header class="app-header">
  <h2 class="title">사회기반시설 스마트 유지관리 시스템</h2>
</header>
