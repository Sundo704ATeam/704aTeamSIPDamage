<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="d-flex flex-column p-3 h-100" style="min-width: 240px; background-color:#2c3e50; color:white;">

  <!-- 메뉴 -->
  <ul class="nav nav-pills flex-column mb-3">
    <li class="nav-item">
      <a href="#" class="nav-link active text-white">HOME</a>
    </li>
    <li>
      <a href="#" class="nav-link text-white">노후화 패턴분석</a>
    </li>
    <li>
      <a href="#" class="nav-link text-white">손상진단 시뮬레이션</a>
    </li>
  </ul>

  <!-- 시설 선택 -->
  <div>
    <label class="form-label text-white">사회기반시설 선택</label>
    <div class="d-grid gap-2">
      <button id="btnBridge" class="btn btn-light btn-sm">교량</button>
      <button id="btnFootbridge" class="btn btn-light btn-sm">육교</button>
      <button id="btnTunnel" class="btn btn-light btn-sm">터널</button>
      <button id="btnAge" class="btn btn-light btn-sm">나이</button>
      <button id="btnAll" class="btn btn-light btn-sm">전체 보기</button>
      <button id="btnAlldown" class="btn btn-light btn-sm">전체 해제</button>
    </div>
  </div>

</div>
