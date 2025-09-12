<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교량 상세</title>
<style>
  body { font-family: Arial, sans-serif; margin: 20px; }
  .container { max-width: 700px; margin: auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
  .bridge-name { font-size: 28px; font-weight: bold; margin-bottom: 10px; }
  .bridge-ufid { font-size: 16px; color: #666; margin-bottom: 20px; }
  .bridge-info { margin-top: 10px; }
  .bridge-info div { padding: 8px 0; border-bottom: 1px solid #eee; }
  .label { font-weight: bold; display: inline-block; width: 100px; }
</style>
</head>
<body>
<div class="container">
  <!-- 교량명 -->
  <div class="bridge-name">교량명:${bridge.name}</div>
  <!-- 관리 번호(ufid) -->
  <div class="bridge-ufid">고유번호: ${bridge.ufid}</div>

  <!-- 나머지 속성들 -->
  <div class="bridge-info">
    <div><span class="label">연장:</span> ${bridge.leng} m</div>
    <div><span class="label">폭:</span> ${bridge.widt} m</div>
    <div><span class="label">건축얀도:</span> ${bridge.eymd}</div>
    <div><span class="label">기타:</span> ${bridge.rest}</div>
    <div><span class="label">통합코드:</span> ${bridge.scls}</div>
    <div><span class="label">제작정보:</span> ${bridge.fmta}</div>
  </div>
</div>
</body>
</html>
