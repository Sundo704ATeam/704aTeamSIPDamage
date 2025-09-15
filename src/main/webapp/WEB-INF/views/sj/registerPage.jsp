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
        <td class="label">건축물 구분:</td>
        <td>
          <select name="category">
            <option value="교량">교량</option>
            <option value="터널">터널</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">종별:</td>
        <td>
          <select name="usage">
            <option value="1종">1종</option>
            <option value="2종">2종</option>
            <option value="3종">3종</option>
          </select>
        </td>
      </tr>
      <tr>
        <td class="label">위치:</td>
        <td><input type="text" name="address" /></td>
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
        <td></td>
        <td><button type="submit">등록</button></td>
      </tr>
    </table>
  </form>
</body>
</html>
