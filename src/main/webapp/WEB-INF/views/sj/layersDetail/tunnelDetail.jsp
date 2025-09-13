<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>터널 상세</title>
<style>
  body { font-family: Arial, sans-serif; margin: 20px; }
  .container { max-width: 700px; margin: auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
  .tunnel-name { font-size: 28px; font-weight: bold; margin-bottom: 10px; }
  .tunnel-ufid { font-size: 16px; color: #666; margin-bottom: 20px; }
  .tunnel-info { margin-top: 10px; }
  .tunnel-info div { padding: 8px 0; border-bottom: 1px solid #eee; }
  .label { font-weight: bold; display: inline-block; width: 100px; }
</style>
</head>
<body>
<div class="container">
  <!-- 터널명 -->
  <div class="tunnel-name">터널명:${tunnel.name}</div>
  <!-- 관리 번호(ufid) -->
  <div class="tunnel-ufid">고유번호: ${tunnel.ufid}</div>

  <!-- 나머지 속성들 -->
  <div class="tunnel-info">
    <div><span class="label">길이:</span> ${tunnel.leng} m</div>
    <div><span class="label">폭:</span> ${tunnel.widt} m</div>
    <div><span class="label">높이:</span> ${tunnel.heig}</div>
    <div><span class="label">통합코드:</span> ${tunnel.scls}</div>
    <div><span class="label">제작정보:</span> ${tunnel.fmta}</div>
  </div>
</div>
</body>
</html>
