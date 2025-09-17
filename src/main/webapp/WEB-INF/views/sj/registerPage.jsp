<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>건물 등록</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h2 { margin-bottom: 20px; }
    .form-table td { padding: 8px 12px; }
    .form-table td.label { text-align: right; font-weight: bold; width: 120px; }
    input, select {
      width: 300px;
      padding: 6px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
    .card { padding: 20px; }
  </style>
</head>
<body>
  <h2>건물 등록 페이지</h2>

  <form action="${pageContext.request.contextPath}/sj/saveBuilding" method="post">
    <div class="d-flex gap-4">
      
      <!-- ✅ 왼쪽 카드 -->
      <div class="card flex-fill">
        <h5 class="mb-3">기본 정보</h5>
        <table class="form-table">
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
                <option value="건물">건물</option>
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
            <td><input type="text" name="address" value="${address}" /></td>
          </tr>
          <tr>
            <td class="label">X 좌표:</td>
            <td><input type="text" name="x" value="${x}" readonly /></td>
          </tr>
          <tr>
            <td class="label">Y 좌표:</td>
            <td><input type="text" name="y" value="${y}" readonly /></td>
          </tr>
          <tr>
            <td class="label">구조:</td>
            <td>
              <select name="materials" id="materials">
                <option value="철골">철골</option>
                <option value="벽돌">벽돌</option>
                <option value="모래">모래</option>
                <option value="기타">기타</option>
              </select>
              <input type="text" id="materialsCustom" name="materialsCustom"
                     placeholder="직접 입력"
                     style="display:none; margin-top:8px; width:300px; padding:6px; border:1px solid #ccc; border-radius:4px;">
            </td>
          </tr>
        </table>
      </div>

      <!-- ✅ 오른쪽 카드 -->
      <div class="card flex-fill">
        <h5 class="mb-3">영향도</h5>
        <table class="form-table">
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
        </table>
      </div>
    </div>

    <!-- 버튼 -->
    <div class="mt-3 text-end">
      <button type="submit" class="btn btn-primary">등록</button>
    </div>
  </form>

  <script>
    // ✅ 세부 구분 스크립트
    const subcategories = {
      "교량": ["도로교량", "복개구조물", "철도교량","육교"],
      "터널": ["도로터널", "지하차도", "철도터널","방음터널"],
      "하천": ["하구독", "수문 및 통문", "제방", "보", "배수펌프장"],
      "상하수도": ["광역상수도", "공업용수도", "지방상수도","공공하수처리시설","폐기물매립시설"],
      "옹벽": ["도로용벽", "철도옹벽","항만용벽","댐용벽","건축물용벽","기타용벽"],
      "절토사면": ["도로사면", "철도사면","항만사면","댐사면","건축물사면","기타사면"],
      "건물": ["공동주택","대형건축물","다중이용건축물", "철도역시설", "지하도상가","기타"]
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

    // ✅ 기타 선택 시 입력창 표시
    const select = document.getElementById("materials");
    const customInput = document.getElementById("materialsCustom");
    select.addEventListener("change", function() {
      if (this.value === "기타") {
        customInput.style.display = "block";
        customInput.required = true;
      } else {
        customInput.style.display = "none";
        customInput.required = false;
        customInput.value = "";
      }
    });
  </script>
</body>
</html>
