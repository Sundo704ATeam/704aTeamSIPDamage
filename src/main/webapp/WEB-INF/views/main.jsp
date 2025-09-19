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
      padding: 20px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      grid-template-rows: 1fr 1fr;
      gap: 20px;
      box-sizing: border-box;
    }

    .card {
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      padding: 20px;
      display: flex;
      flex-direction: column;
      height: 100%;
    }

    .card h3 {
      margin: 0 0 15px;
      text-align: center;
      font-size: 20px;
      font-weight: 600;
      color: #333;
    }

    /* 카테고리 버튼 */
    .category-btn {
      padding: 8px 16px;
      margin: 0 4px;
      background: #f0f0f0;
      border: 1px solid #ccc;
      border-radius: 20px;
      font-size: 14px;
      font-weight: 500;
      color: #333;
      cursor: pointer;
      transition: all 0.2s ease-in-out;
    }
    .category-btn:hover {
      background: #e0eaff;
      border-color: #4a90e2;
      color: #1a4fa3;
    }
    .category-btn.active {
      background: linear-gradient(135deg, #4a90e2, #357ab8);
      color: #fff;
      border: none;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2);
    }

    /* 표 */
    .top5-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }
    .top5-table th, .top5-table td {
      border: 1px solid #ddd;
      padding: 10px;
      font-size: 15px;
      text-align: center;
      height: 42px;
      word-wrap: break-word;
    }
    .top5-table th {
      background: #f0f0f0;
      font-weight: bold;
    }

    .btn-detail {
      padding: 6px 12px;
      background: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 14px;
      cursor: pointer;
    }
    .btn-detail:hover { background: #0056b3; }

    .graph-area {
      flex: 1;
      background: #f7f7f7;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 16px;
      color: #666;
    }

    .card ul {
      font-size: 15px;
      padding-left: 20px;
      margin: 0;
      line-height: 1.8;
    }

    @media (max-width: 1100px) {
      #content {
        grid-template-columns: 1fr;
        grid-template-rows: auto;
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

    <!-- 2번 카드 -->
    <div class="card">
      <h3>🚨 긴급 점검 필요 건물 리스트</h3>
      <div id="urgent-list" style="flex:1; display:flex; align-items:center; justify-content:center; color:#777;">
        리스트 들어갈 자리
      </div>
    </div>

    <!-- 3번 카드 -->
    <div class="card">
      <h3>📊 그래프 영역</h3>
      <div class="graph-area">그래프 들어갈 자리</div>
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

  <script>
    const CTX = '<%= request.getContextPath() %>';

    function selectCategory(btn, endpoint) {
      document.querySelectorAll(".category-btn").forEach(b => b.classList.remove("active"));
      btn.classList.add("active");
      loadTop5(endpoint);
    }

    function loadTop5(endpoint) {
    	  fetch(endpoint)
    	    .then(res => res.json())
    	    .then(data => {
    	      const tbody = document.querySelector("#list-area tbody");
    	      tbody.innerHTML = "";

    	      if (!Array.isArray(data) || data.length === 0) {
    	        tbody.innerHTML = "<tr><td colspan='5'>데이터 없음</td></tr>";
    	        return;
    	      }

    	      data.forEach(item => {
    	        const type = item.type || '-';
    	        const name = item.name || '-';
    	        const diff = item.diff ?? 0;

    	        const tr = document.createElement("tr");
    	        tr.innerHTML =
    	          "<td>" + type + "</td>" +
    	          "<td>" + name + "</td>" +
    	          "<td>" + diff + "</td>" +
    	          "<td>" +
    	            "<button class='btn-detail' " +
    	            "onclick=\"window.open('" + CTX + "/inspectList?managecode=" + item.managecode + "', " +
    	            "'inspectWin','width=1000,height=600,scrollbars=yes,resizable=yes');\">" +
    	            "점검 내역</button>" +
    	          "</td>" +
    	          "<td>" +
    	            "<a href='" + CTX + "/structureDetail?managecode=" + item.managecode + "' " +
    	            "class='btn-detail'>상세보기</a>" +
    	          "</td>";
    	        tbody.appendChild(tr);
    	      });
    	    })
    	    .catch(err => console.error("에러:", err));
    	}

    document.addEventListener("DOMContentLoaded", () => {
      loadTop5(CTX + "/risk/top5/crack");
    });
    
    
  </script>
</body>
</html>
