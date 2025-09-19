<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>사회기반시설 스마트 유지관리 시스템</title>
  <style>
    body { font-family: 'Segoe UI', sans-serif; margin:0; background:#f5f6fa; }

    #content {
      padding:20px;
      margin-left:200px; /* 사이드바 폭만큼 */
    }

    .card {
      max-width: 800px;
      margin: 20px auto;
      background:#fff;
      border-radius:8px;	
      box-shadow:0 2px 6px rgba(0,0,0,0.1);
      padding:16px;
    }

    .card h3 { margin:0 0 10px; text-align:center; }

    button {
      margin-bottom: 10px;
      padding: 6px 12px;
      border: 1px solid #ccc;
      border-radius: 6px;
      background: #f0f0f0;
      cursor: pointer;
    }
    button:hover { background: #e0e0e0; }

    .top5-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 10px;
    }

    .top5-table th, .top5-table td {
      border: 1px solid #ddd;
      padding: 8px;
      font-size: 14px;
      text-align: center;
    }

    .top5-table th {
      background: #f8f8f8;
      font-weight: bold;
    }

    .btn-detail {
      padding: 4px 8px;
      background: #007bff;
      color: #fff;
      border: none;
      border-radius: 4px;
      font-size: 12px;
      cursor: pointer;
    }
    .btn-detail:hover {
      background: #0056b3;
    }
  </style>
</head>
<body>
  <jsp:include page="/WEB-INF/views/header.jsp"/>
  <jsp:include page="/WEB-INF/views/sidebar.jsp"/>

  <div id="content">
    <div class="card">
      <h3>📋 위험도 변동 건물 Top5</h3>
      <div style="text-align:center;">
        <button onclick="loadTop5(CTX + '/risk/top5/crack')">균열</button>
        <button onclick="loadTop5(CTX + '/risk/top5/elecleak')">누전</button>
        <button onclick="loadTop5(CTX + '/risk/top5/leak')">누수</button>
        <button onclick="loadTop5(CTX + '/risk/top5/variation')">변형</button>
        <button onclick="loadTop5(CTX + '/risk/top5/abnormality')">구조이상</button>
      </div>

      <table id="list-area" class="top5-table">
        <thead>
          <tr>
            <th>종류</th>
            <th>시설물명</th>
            <th>변동률</th>
            <th>점검 내역</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>

    <div class="card">
      <h3>📊 그래프 영역</h3>
      <div style="height:300px; background:#f0f0f0; display:flex; align-items:center; justify-content:center;">
        그래프 들어갈 자리
      </div>
    </div>
  </div>

  <script>
    // JSP contextPath JS 변수로 주입
    const CTX = '<%= request.getContextPath() %>';

    function loadTop5(endpoint) {
      fetch(endpoint)
        .then(res => res.json())
        .then(data => {
          console.log("받은 데이터:", data);
          const tbody = document.querySelector("#list-area tbody");
          tbody.innerHTML = "";

          if (!Array.isArray(data) || data.length === 0) {
            tbody.innerHTML = "<tr><td colspan='4'>데이터 없음</td></tr>";
            return;
          }

          data.forEach(item => {
            const type = item.type || '-';
            const name = item.name || '-';
            const diff = (item.diff !== null && item.diff !== undefined) ? item.diff : 0;

            const tr = document.createElement("tr");
            tr.innerHTML =
              "<td>" + type + "</td>" +
              "<td>" + name + "</td>" +
              "<td>" + diff + "</td>" +
              "<td>" +
                "<button class='btn-detail' " +
                "onclick=\"window.open('" + CTX + "/inspectList?managecode=" + item.managecode + "', " +
                "'inspectWin','width=1000,height=600,scrollbars=yes,resizable=yes');\">" +
                "바로가기</button>" +
              "</td>";
            tbody.appendChild(tr);
          });
        })
        .catch(err => console.error("에러:", err));
    }

    // 기본값: 균열
    document.addEventListener("DOMContentLoaded", () => {
      loadTop5(CTX + "/risk/top5/crack");
    });
  </script>	
</body>
</html>
