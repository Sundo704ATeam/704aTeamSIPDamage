<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>육교 상세</title>
<style>
  body { font-family: Arial, sans-serif; margin: 20px; }
  .container { max-width: 700px; margin: auto; border: 1px solid #ddd; border-radius: 8px; padding: 20px; }
  .footbridge-name { font-size: 28px; font-weight: bold; margin-bottom: 10px; }
  .footbridge-ufid { font-size: 16px; color: #666; margin-bottom: 20px; }
  .footbridge-info { margin-top: 10px; }
  .footbridge-info div { padding: 8px 0; border-bottom: 1px solid #eee; }
  .label { font-weight: bold; display: inline-block; width: 100px; }
</style>
</head>
<body>
<div class="container">
  <!-- 교량명 -->
 <div class="footbridge-name">
    육교명: ${footbridge.name != null ? footbridge.name : "없음"}
 </div>  <!-- 관리 번호(ufid) -->
 <div class="footbridge-ufid">
    고유번호: ${footbridge.ufid != null ? footbridge.ufid : "없음"}
  </div>
  
  <!-- 나머지 속성들 -->
  <div class="footbridge-info">
    <div><span class="label">길이:</span> ${footbridge.leng} m</div>
    <div><span class="label">폭:</span> ${footbridge.widt} m</div>
    <div><span class="label">높이:</span> ${footbridge.heig}</div>
    <div><span class="label">기타:</span> ${footbridge.rest != null ? footbridge.rest : "없음"}</div>
    <div><span class="label">통합코드:</span> ${footbridge.scls}</div>
    <div><span class="label">제작정보:</span> ${footbridge.fmta}</div>
  </div>
</div>
</body>
</html>
