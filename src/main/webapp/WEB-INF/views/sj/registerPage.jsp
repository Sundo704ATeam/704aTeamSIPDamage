<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>건물 등록</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h2 { margin-bottom: 20px; }
    table { border-collapse: collapse; }
    td { padding: 8px 12px; }
    td.label { text-align: right; font-weight: bold; }
    input, select {
      width: 220px;
      padding: 6px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    button {
      margin-top: 15px;
      padding: 8px 16px;
      background: #2563eb;
      color: #fff;
      border: none;
      border-radius: 4px;
      cursor: pointer;
    }
    button:hover { background: #1d4ed8; }
  </style>
</head>
<body>
  <h2>건물 등록 페이지</h2>
  <form action="${pageContext.request.contextPath}/sj/saveBuilding" method="post">
    <table>
      <tr>
        <td class="label">건물명:</td>
        <td><input type="text" name="name" /></td>
      </tr>
      <tr>
        <td class="label">종류:</td>
        <td>
          <select name="type" id="category" onchange="updateSubcategory()">
            <option value="">-- 선택 --</option>
            <option value="교량">교량</option>
            <option value="터널">터널</option>
            <option value="하천">하천</option>
            <option value="상하수도">상하수도</option>
            <option value="옹벽">옹벽</option>
            <option value="절토사면">절토사면</option>
            <option value="건물">건축물</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">세부 구분:</td>
        <td>
          <select name="typedetail" id="subcategory">
            <option value="">-- 먼저 종류를 선택하세요 --</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">종별:</td>
        <td>
          <select name="sort">
            <option value="1종">1종</option>
            <option value="2종">2종</option>
            <option value="3종">3종</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">위치:</td>
        <td><input type="text" name="address" value="${address}" /> </td>
      </tr>
      <tr>
        <td class="label">X 좌표:</td>
        <td><input type="text" name="x" value="${x}" readonly /></td>
      </tr>
      <tr>
        <td class="label">Y 좌표:</td>
        <td><input type="text" name="y" value="${y}" readonly /></td>
      </tr>

      <!-- ✅ 영향도 항목 추가 -->
      <tr>
        <td class="label">균열:</td>
        <td>
          <select name="crack">
            <option value="10">A</option>
            <option value="8">B</option>
            <option value="6">C</option>
            <option value="4">D</option>
            <option value="2">E</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">누전:</td>
        <td>
          <select name="elecleak">
            <option value="10">A</option>
            <option value="8">B</option>
            <option value="6">C</option>
            <option value="4">D</option>
            <option value="2">E</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">누수:</td>
        <td>
          <select name="leak">
            <option value="10">A</option>
            <option value="8">B</option>
            <option value="6">C</option>
            <option value="4">D</option>
            <option value="2">E</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">변형:</td>
        <td>
          <select name="variation">
            <option value="10">A</option>
            <option value="8">B</option>
            <option value="6">C</option>
            <option value="4">D</option>
            <option value="2">E</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">구조이상:</td>
        <td>
          <select name="abnormality">
            <option value="10">A</option>
            <option value="8">B</option>
            <option value="6">C</option>
            <option value="4">D</option>
            <option value="2">E</option>
          </select>
        </td>
      </tr>

      <tr>
        <td></td>
        <td><button type="submit">등록</button></td>
      </tr>
    </table>
  </form>

  <script>
    // ✅ 종류별 세부 구분 목록
    const subcategories = {
      "교량": ["도로교량", "복개구조물", "철도교량","육교"],
      "터널": ["도로터널", "지하차도", "철도터널","방음터널"],
      "하천": ["하구독", "수문 및 통문", "제방", "보", "배수펌프장"],
      "상하수도": ["광역상수도", "공업용수도", "지방상수도","공공하수처리시설","폐기물매립시설"],
      "옹벽": ["도로용벽", "철도옹벽","항만용벽","댐용벽","건축물용벽","기타용벽"],
      "절토사면": ["도로사면", "철도사면","항만사면","댐사면","건축물사면","기타사면"],
      "건축물": ["공동주택","대형건축물","다중이용건축물", "철도역시설", "지하도상가","기타"]
    };

    function updateSubcategory() {
      const category = document.getElementById("category").value;
      const subSelect = document.getElementById("subcategory");

      subSelect.innerHTML = "";

      if (category && subcategories[category]) {
        subcategories[category].forEach(item => {
          const opt = document.createElement("option");
          opt.value = item;
          opt.text = item;
          subSelect.appendChild(opt);
        });
      } else {
        const opt = document.createElement("option");
        opt.value = "";
        opt.text = "-- 먼저 구분을 선택하세요 --";
        subSelect.appendChild(opt);
      }
    }
  </script>
</body>
</html>
