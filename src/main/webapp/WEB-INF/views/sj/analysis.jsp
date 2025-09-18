<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>손상 이력 그래프</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    #historyChart { max-width: 100%; height: 150px; }
    .no-data { color: #888; font-size: 14px; text-align: center; padding: 20px; }
  </style>
</head>
<body>
  <canvas id="historyChart"></canvas>

  <script>
	  const managecode = "${param.managecode}";
	  console.log("전달된 managecode:", managecode);

    if (!managecode) {
      document.getElementById("historyChart").outerHTML =
        "<div class='no-data'>⚠ 관리코드가 전달되지 않았습니다.</div>";
    } else {
      fetch("${pageContext.request.contextPath}/analysis/stats/history?managecode=" + managecode)
        .then(res => res.json())
        .then(data => {
          if (!data || data.length === 0) {
            document.getElementById("historyChart").outerHTML =
              "<div class='no-data'>📭 점검 이력이 없습니다.</div>";
            return;
          }

          const labels = data.map(r => r.ins_date);
          const crack = data.map(r => r.crack);
          const elec  = data.map(r => r.elecleak);
          const leak  = data.map(r => r.leak);
          const vario = data.map(r => r.variation);
          const abn   = data.map(r => r.abnormality);

          
          new Chart(document.getElementById("historyChart"), {
            type: "line",
            data: {
              labels,
              datasets: [
                { label:"균열", data:crack, borderColor:"red", fill:false },
                { label:"누전", data:elec, borderColor:"blue", fill:false },
                { label:"누수", data:leak, borderColor:"orange", fill:false },
                { label:"변형", data:vario, borderColor:"green", fill:false },
                { label:"구조이상", data:abn, borderColor:"purple", fill:false }
                
              ]
            },
            options:{
              responsive:true, maintainAspectRatio:false,
              plugins:{ legend:{ position:'top' }, tooltip:{ mode:'index', intersect:false } },
              scales:{ y:{ beginAtZero:true } }
            }
          });
        })
        .catch(err => {
          console.error("그래프 로드 실패:", err);
          document.getElementById("historyChart").outerHTML =
            "<div class='no-data'>⚠ 그래프 로드 실패</div>";
        });
    }
  </script>
</body>
</html>
