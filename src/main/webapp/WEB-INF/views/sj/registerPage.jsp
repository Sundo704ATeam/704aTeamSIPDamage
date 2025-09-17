<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  <%-- ✅ JSTL 필요 --%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>건물 등록</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h2 { margin-bottom: 20px; }

    /* ✅ 카드 정렬 */
    .form-row {
      display: flex;
      flex-wrap: wrap;
      gap: 20px;
    }
    .form-row .card {
      flex: 1 1 400px;   /* 최소 400px, 그 이상은 균등 분배 */
      box-sizing: border-box;
    }

    /* ✅ 카드 안쪽 폼 레이아웃 */
    .form-grid {
      display: grid;
      grid-template-columns: 120px 1fr;
      row-gap: 12px;
      column-gap: 2px;
      align-items: left;
    }
    .form-grid label {
      font-weight: bold;
      text-align: left;
    }
    .form-grid input,
    .form-grid select {
      width: 100%;
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
    <div class="form-row">
      
      <!-- ✅ 왼쪽 카드 -->
      <div class="card">
        <h5 class="mb-3">기본 정보</h5>
        <div class="form-grid">
          <label>건물명:</label>
          <input type="text" name="name" />

          <label>종류:</label>
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

          <label>세부 구분:</label>
          <select name="typedetail" id="subcategory">
            <option value="">-- 먼저 종류를 선택하세요 --</option>
          </select>

          <label>종별:</label>
          <select name="sort">
            <option value="1종">1종</option>
            <option value="2종">2종</option>
            <option value="3종">3종</option>
          </select>

          <label>위치:</label>
          <input type="text" name="address" value="${address}" />

          <label>X 좌표:</label>
          <input type="text" name="x" value="${x}" readonly />

          <label>Y 좌표:</label>
          <input type="text" name="y" value="${y}" readonly />

          <label>구조:</label>
          <div>
            <select name="materials" id="materials">
              <option value="철골">철골</option>
              <option value="벽돌">벽돌</option>
              <option value="모래">모래</option>
              <option value="기타">기타</option>
            </select>
            <input type="text" id="materialsCustom" name="materialsCustom"
                   placeholder="직접 입력"
                   style="display:none; margin-top:8px;"/>
          </div>
        </div>
      </div>

      <!-- ✅ 오른쪽 카드 -->
      <div class="card">
        <h5 class="mb-3">영향도</h5>
        <div class="form-grid">
          <label>균열:</label>
          <select name="crack">
            <option value="10">A</option><option value="8">B</option>
            <option value="6">C</option><option value="4">D</option><option value="2">E</option>
          </select>

          <label>누전:</label>
          <select name="elecleak">
            <option value="10">A</option><option value="8">B</option>
            <option value="6">C</option><option value="4">D</option><option value="2">E</option>
          </select>

          <label>누수:</label>
          <select name="leak">
            <option value="10">A</option><option value="8">B</option>
            <option value="6">C</option><option value="4">D</option><option value="2">E</option>
          </select>

          <label>변형:</label>
          <select name="variation">
            <option value="10">A</option><option value="8">B</option>
            <option value="6">C</option><option value="4">D</option><option value="2">E</option>
          </select>

          <label>구조이상:</label>
          <select name="abnormality">
            <option value="10">A</option><option value="8">B</option>
            <option value="6">C</option><option value="4">D</option><option value="2">E</option>
          </select>
        </div>
      </div>
    </div>
			<!-- 버튼 -->
			<div class="mt-3 text-end d-flex justify-content-end align-items-center gap-3">
			  <!-- 즐겨찾기 체크박스 -->
			  <div class="form-check">
			    <input class="form-check-input custom-checkbox" type="checkbox" id="favoriteChk" name="hoshi" value="1">
			    <label class="form-check-label ms-1" for="favoriteChk">즐겨찾기</label>
			  </div>
			
			  <!-- hidden 기본값 (0) -->
			  <input type="hidden" name="hoshi" value="0"/>
			
			  <!-- 등록 버튼 -->
			  <button type="submit" class="btn btn-primary">등록</button>
			</div>

  </form>

  <script>
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

  <!-- ✅ 등록 성공 시 팝업 + 창닫기 -->
  <c:if test="${success}">
    <script>
      window.onload = function() {
        alert("등록이 완료되었습니다.");
        window.close();
      }
    </script>
  </c:if>

</body>
</html>
