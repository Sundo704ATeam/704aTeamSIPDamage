<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>
  <style>

    :root {
      --header-h: 60px;
      --sidebar-w: 200px;
    }

    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background: #f5f6fa;
    }

    #content {
      margin-left: var(--sidebar-w);
      margin-top: var(--header-h);
      height: calc(100vh - var(--header-h));
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-template-rows: 1fr 1fr;
      gap: 20px;
      padding: 20px;
      box-sizing: border-box;
    }

    .card {
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      display: flex;
      flex-direction: column;
      min-height: 0;   /* ✅ grid/flex 자식 스크롤 버그 방지 */
    }

    .card h3 {
      margin: 0;
      padding: 12px;
      text-align: center;
      font-size: 18px;
      font-weight: 600;
      color: #333;
      border-bottom: 1px solid #eee;
      flex-shrink: 0;
    }

    .card-body {
      flex: 1;
      min-height: 0;
      overflow-y: auto; /* ✅ 내용 스크롤 */
      padding: 12px;
      box-sizing: border-box;
    }

    /* 버튼 */
    .category-btn {
      padding: 6px 14px;
      margin: 0 4px 10px 4px;
      background: #f0f0f0;
      border: 1px solid #ccc;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 500;
      color: #333;
      cursor: pointer;
    }
    .category-btn.active {
      background: linear-gradient(135deg, #4a90e2, #357ab8);
      color: #fff;
      border: none;
    }

    /* 표 */
    .top5-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
    }
    .top5-table th, .top5-table td {
      border: 1px solid #ddd;
      padding: 8px;
      text-align: center;
      word-break: break-word;
    }
    .top5-table th {
      background: #f8f8f8;
      font-weight: 600;
    }

    .btn-detail {
      padding: 4px 10px;
      background: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 12px;
      cursor: pointer;
    }
    .btn-detail:hover { background: #0056b3; }

    /* ✅ 테이블 공통 스크롤 처리 */
    .card .table-wrapper {
      flex: 1;
      overflow-y: auto;
      min-height: 0;
    }

    /* 그래프 */
    .graph-area {
      flex: 1;
      min-height: 0;
      display: flex;
      align-items: stretch;
      justify-content: center;
      overflow: hidden;
      padding: 8px;
      box-sizing: border-box;
    }
    .graph-area canvas {
      width: 100% !important;
      height: 100% !important;
      max-width: 100%;
      max-height: 100%;
      object-fit: contain;
    }

    @media (max-width: 1100px) {
      #content {
        grid-template-columns: 1fr;
        grid-template-rows: auto;  /* ✅ 자동 높이 */
      }
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <div id="content">

		<!-- 1번 카드 -->
		<div class="card">
		  <h3>📋 위험도 변동 건물 Top5</h3>
		  <div style="text-align:center; margin-bottom:10px;">
		    <button class="category-btn active" onclick="selectCategory(this, CTX + '/risk/top5/crack')">균열</button>
		    <button class="category-btn" onclick="selectCategory(this, CTX + '/risk/top5/elecleak')">누전</button>
		    <button class="category-btn" onclick="selectCategory(this, CTX + '/risk/top5/leak')">누수</button>
		    <button class="category-btn" onclick="selectCategory(this, CTX + '/risk/top5/variation')">변형</button>
		    <button class="category-btn" onclick="selectCategory(this, CTX + '/risk/top5/abnormality')">구조이상</button>
		  </div>
		
		  <!-- ✅ 스크롤 감싸는 div 추가 -->
		  <div class="table-wrapper">
		    <table id="list-area" class="top5-table">
		      <thead>
		        <tr>
		          <th>종류</th>
		          <th>시설물명</th>
		          <th>변동률</th>
		          <th>점검 내역</th>
		          <th>건물 정보</th>
		        </tr>
		      </thead>
		      <tbody></tbody>
		    </table>
		  </div>
		</div>

    <!-- 2번 카드 -->
    <div class="card emergency">
      <h3>🚨 긴급 점검 필요 건물 리스트</h3>
      <div style="text-align:center; margin-bottom:10px;">
        <button class="category-btn active" onclick="selectEmergency(this, CTX + '/emergency/crack', 'crack')">균열</button>
        <button class="category-btn" onclick="selectEmergency(this, CTX + '/emergency/elecleak', 'elecleak')">누전</button>
        <button class="category-btn" onclick="selectEmergency(this, CTX + '/emergency/leak', 'leak')">누수</button>
        <button class="category-btn" onclick="selectEmergency(this, CTX + '/emergency/variation', 'variation')">변형</button>
        <button class="category-btn" onclick="selectEmergency(this, CTX + '/emergency/abnormality', 'abnormality')">구조이상</button>
      </div>
      <div class="table-wrapper">
        <table id="urgent-table" class="top5-table">
          <thead>
            <tr>
              <th>종류</th>
              <th>시설물명</th>
              <th>등급</th>
              <th>점검 내역</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
    
		<!-- 3번 카드 -->
		<div class="card">
		  <h3>📊 지역구별 위험도 평균</h3>
		  <div style="text-align:center; margin-bottom:10px;">
	<button class="category-btn active" onclick="filterDistrict('전체', this)">전체</button>
	<button class="category-btn" onclick="filterDistrict('마포구', this)">마포구</button>
	<button class="category-btn" onclick="filterDistrict('서대문구', this)">서대문구</button>
	<button class="category-btn" onclick="filterDistrict('종로구', this)">종로구</button>
	<button class="category-btn" onclick="filterDistrict('은평구', this)">은평구</button>

		  </div>
		
		  <!-- ✅ 그래프 전용 감싸는 div 추가 -->
		  <div class="graph-area">
		    <canvas id="riskChart"></canvas>
		  </div>
		</div>

    <!-- 4번 카드 -->
    <div class="card">
      <h3>ℹ️ 용어 설명 및 범례</h3>
      <div style="flex:1; color:#555;">
        <ul>
          <li><b>설명</b>: 설명쓸거임</li>
        </ul>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script>
    const CTX = '<%= request.getContextPath() %>';

    /* 1번카드 */
    function selectCategory(btn, endpoint) {
      document.querySelectorAll(".card:nth-child(1) .category-btn").forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
      loadTop5(endpoint);
    }
    function loadTop5(endpoint) {
      fetch(endpoint).then(res => res.json()).then(data => {
        const tbody = document.querySelector("#list-area tbody");
        tbody.innerHTML = "";
        if (!Array.isArray(data) || data.length === 0) {
          tbody.innerHTML = "<tr><td colspan='5'>데이터 없음</td></tr>";
          return;
        }
        data.forEach(item => {
          const tr = document.createElement("tr");
          tr.innerHTML =
            "<td>" + (item.type || '-') + "</td>" +
            "<td>" + (item.name || '-') + "</td>" +
            "<td>" + (item.diff ?? 0) + "</td>" +
            "<td><button class='btn-detail' onclick=\"window.open('" + CTX + "/inspectList?managecode=" + item.managecode + "','inspectWin','width=1000,height=600,scrollbars=yes,resizable=yes');\">점검 내역</button></td>" +
            "<td><a href='" + CTX + "/structureDetail?managecode=" + item.managecode + "' class='btn-detail'>상세보기</a></td>";
          tbody.appendChild(tr);
        });
      });
    }

    /* 2번카드 */
    function selectEmergency(btn, endpoint, type) {
      document.querySelectorAll(".card:nth-child(2) .category-btn").forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
      loadEmergency(endpoint);
    }
    function loadEmergency(endpoint) {
      fetch(endpoint).then(res => res.json()).then(data => {
        const tbody = document.querySelector("#urgent-table tbody");
        tbody.innerHTML = "";
        if (!Array.isArray(data) || data.length === 0) {
          tbody.innerHTML = "<tr><td colspan='4'>데이터 없음</td></tr>";
          return;
        }
        data.forEach(item => {
          let grade = "-";
          if (item.risk >= 400) grade = "A";
          else if (item.risk >= 300) grade = "B";
          const tr = document.createElement("tr");
          tr.innerHTML =
            "<td>" + (item.type || '-') + "</td>" +
            "<td>" + (item.name || '-') + "</td>" +
            "<td>" + grade + "</td>" +
            "<td><button class='btn-detail' onclick=\"window.open('" + CTX + "/inspectList?managecode=" + item.managecode + "','inspectWin','width=1000,height=600,scrollbars=yes,resizable=yes');\">점검 내역</button></td>";
          tbody.appendChild(tr);
        });
      });
    }

    /* 3번카드 그래프 */
    let graphData = [];
    let currentDistrict = null;
    let chartInstance = null;

    function loadGraph() {
      fetch(CTX + "/risk/avgByDistrict")
        .then(res => res.json())
        .then(data => {
          graphData = data;
          drawChart();
        });
    }

    function drawChart() {
      const ctx = document.getElementById("riskChart").getContext("2d");
      if (chartInstance) chartInstance.destroy();

      const decades = [...new Set(graphData.map(d => d.graph_decade))].sort((a, b) => a - b);
      const filtered = currentDistrict ? graphData.filter(d => d.graph_district === currentDistrict) : graphData;

      function makeDataset(key, label, color) {
        return {
          label: label,
          data: decades.map(dec => {
            const items = filtered.filter(x => x.graph_decade === dec);
            if (!items.length) return null;
            return items.reduce((sum, it) => sum + (it[key] || 0), 0) / items.length;
          }),
          borderColor: color,
          borderWidth: 2,
          tension: 0.2,
          fill: false,
          pointRadius: 4
        };
      }

      const datasets = [
        makeDataset("graph_crack_risk", "균열", "#ff6384"),
        makeDataset("graph_elecleak_risk", "누전", "#36a2eb"),
        makeDataset("graph_leak_risk", "누수", "#ffcd56"),
        makeDataset("graph_variation_risk", "변형", "#4bc0c0"),
        makeDataset("graph_abnormality_risk", "구조이상", "#9966ff")
      ];

      chartInstance = new Chart(ctx, {
        type: "line",
        data: { labels: decades, datasets: datasets },
        options: {
          responsive: true,
          maintainAspectRatio: false,   // ✅ 카드 크기에 맞게 변형 허용
          plugins: { legend: { position: "bottom" } },
          scales: {
            x: { title: { display: true, text: "건축년도 (10년 단위)" } },
            y: { title: { display: true, text: "위험도 평균" }, beginAtZero: true }
          }
        }
      });
    }

    function filterDistrict(district, btn) {
    	  // 모든 버튼에서 active 제거
    	  document.querySelectorAll(".card:nth-child(3) .category-btn")
    	    .forEach(b => b.classList.remove("active"));

    	  // 클릭한 버튼만 active
    	  btn.classList.add("active");

    	  // 필터링 로직
    	  currentDistrict = district === "전체" ? null : district;
    	  drawChart();
    	}

    document.addEventListener("DOMContentLoaded", () => {
      loadTop5(CTX + "/risk/top5/crack");
      loadEmergency(CTX + "/emergency/crack");
      loadGraph();
    });
  </script>
</body>
</html>
